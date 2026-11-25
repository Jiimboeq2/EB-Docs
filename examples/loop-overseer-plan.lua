-- EB tested example: The overseer's daily pass, and how it picks agents
-- loop-overseer-plan | snippet | topics: tasks, helpers
--
-- What it does:  eb.overseer.plan picks by the game's own rules: the order (rescues, the tutorial, plain missions in list order,
--                then charged ones by name), the skips (the day's allowance, the player's switches) and each party - an agent
--                whose traits the mission likes first, an agent with a trait it dislikes never unless the player's option says
--                so. The overseer goal (eb.loops) runs ONE whole pass a bite per tick over the window driver: open the window,
--                read both lists, turn in what is done, start the plan, shut the window it opened. Buying spends coin: only with
--                params.buy.
-- Tested:        The plain mission goes first with the agent it likes, then the charged one with its own; the agent with the
--                disliked trait stays home; the pass turns the finished mission in, starts both, buys nothing and ends "done".
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local Mo = require("eb.overseer.model")
local Plan = require("eb.overseer.plan")
local Op = require("eb.overseer.options")
local Loops = require("eb.loops")

-- the window's reads as a driver hands them (offline: invented missions and agents)
local missionRows = {
    { name = "Fixture Survey [Season II: Charged]", charges = 3, state = "available", slots = 1, positive = { "Lantern Lore" }, negative = {} },
    { name = "Sample Patrol", state = "available", slots = 1, positive = { "Fixturecraft" }, negative = { "Clumsy" } },
    { name = "Example Ruins", state = "complete" },
}
local agentRows = {
    { name = "Fixture Archer", status = "idle", traits = { "Fixturecraft" } },
    { name = "Fixture Sage", status = "idle", traits = { "Lantern Lore" } },
    { name = "Fixture Tinker", status = "idle", traits = { "Clumsy" } },
}

-- your script: the plan on its own (the rows made into EB's shapes first)
local missions, agents = {}, {}
for _, r in ipairs(missionRows) do missions[#missions + 1] = Mo.mission(r, 0) end
for _, a in ipairs(agentRows) do agents[#agents + 1] = Mo.agent(a) end
local plan = Plan.make(missions, agents, Op.defaults(), { plainLeft = 10 })
print(("plan: %d start(s), %d agent(s) left"):format(#plan.starts, plan.left))

-- and the whole pass as the goal, driven by hand (in game the brain calls goal:advance once per tick) over a driver
-- that has the base verbs only: the turn-in and the start go through its composites (collect, assign)
local started, turnedIn, bought = {}, 0, false
local ov = {
    near = function() return true end, open = function() return "done" end,
    state = function() return { finished = 1, openSlots = 2, idleAgents = 3, scrolls = 0 } end,
    missions = function() return missionRows, { at = 0, complete = true } end,
    agents = function() return agentRows, { at = 0, complete = true } end,
    collect = function() turnedIn = turnedIn + 1; return "done" end,
    addScrolls = function() return "done" end, research = function() return "done" end,
    assign = function(key, agentKeys) started[#started + 1] = key .. ": " .. table.concat(agentKeys, ", "); return "done" end,
    buy = function() bought = true; return "done" end,
}
local b = { sub = {}, logs = {}, cfg = {} }
function b:log(fmt, ...) self.logs[#self.logs + 1] = select("#", ...) > 0 and fmt:format(...) or fmt end
function b:markPointer() end
local goal = Loops.new({ kind = "overseer", params = { act = { overseer = ov }, options = Op.defaults() } })
local status
for _ = 1, 40 do status = goal:advance(b, { zone = "Fixture Docks", now = 0 }); if status ~= "working" then break end end

-- check
DOCS.eq(plan.starts[1].m.name, "Sample Patrol", "the plain mission is tried first")
DOCS.eq(plan.starts[1].party[1].name, "Fixture Archer", "with the agent whose trait it likes")
DOCS.eq(plan.starts[2].party[1].name, "Fixture Sage", "then the charged one, with its own")
DOCS.eq(plan.left, 1, "the agent with the disliked trait stays home")
DOCS.eq(status, "done", "the pass ends")
DOCS.eq(turnedIn, 1, "the finished mission was turned in")
DOCS.eq(#started, 2, "both missions were started")
DOCS.eq(bought, false, "no scrolls bought without params.buy")
