-- EB tested example: A chore loop's stop flag and coin gate
-- loop-stop-and-gates | snippet | topics: tasks, helpers
--
-- What it does:  Every chore loop checks its stop predicate first, on every tick: when it answers true the goal ends at once,
--                before any action. Coin-spending steps (the overseer's buy, a mercenary hire) run only behind an explicit flag.
--                Drive a goal yourself by calling goal:advance(brain, snapshot) once per tick.
-- Tested:        The stopped goal ends on its first tick with nothing done; the mercenary goal unsuspends a suspended merc and
--                never hires without allowHire.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local Loops = require("eb.loops")

-- a minimal brain for driving a goal by hand: b.sub.* adapters, b:log, b:markPointer
local function brainStub()
    local b = { sub = { nav = { travelTo = function() return "arrived" end, walkTo = function() return "arrived" end } },
                logs = {}, cfg = {} }
    function b:log(fmt, ...) self.logs[#self.logs + 1] = select("#", ...) > 0 and fmt:format(...) or fmt end
    function b:markPointer() end
    return b
end
local snap = { zone = "Fixture Docks", x = 0, y = 0, z = 0 }

local touched = false
local stopped = Loops.new({ kind = "mercenary", params = { stop = function() return true end,
    act = { mercenary = { active = function() touched = true; return "none" end } } } })
local first = stopped:advance(brainStub(), snap)

local state, hired = "suspended", false
local merc = { active = function() return state end, contactNear = function() return true end,
               offers = function() return { { id = "k1", role = "healer", cost = 400 } } end,
               hire = function() hired = true; return "done" end,
               unsuspend = function() state = "active"; return "done" end, addFromBags = function() return "done" end }
local goal = Loops.new({ kind = "mercenary", params = { act = { mercenary = merc }, role = "healer" } })
local b, status = brainStub(), nil
for _ = 1, 10 do status = goal:advance(b, snap); if status ~= "working" then break end end
print("mercenary: " .. state .. " (unsuspended)")

DOCS.eq(first, "done", "a stop ends the goal on its first tick")
DOCS.eq(touched, false, "nothing was read or done")
DOCS.eq(status, "done", "the mercenary pass finishes")
DOCS.eq(state, "active", "the suspended merc was brought back (free, safe)")
DOCS.eq(hired, false, "no hire without params.allowHire")
DOCS.check(Loops.describeAll().overseer ~= nil, "describeAll explains every kind and its params")
