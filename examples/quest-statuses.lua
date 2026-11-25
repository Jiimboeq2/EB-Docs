-- What quests.step answers, and what to do with it
--
-- quests.step(run) does one bounded bite and returns at once with a status: working, step_done, need_travel (a zone), need_combat (a target), need_loot, complete or blocked (a reason). The runner never waits; the caller acts on the need_* statuses and calls again.
--
-- kind:      snippet
-- expect:    The trace shows each status once in order; the walk, the trip, the fight and the loot each happened once.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.quest
-- id:        quest-statuses

local PACK = {
    schema = "eb-quest/1", quest_name = "Fixture Basics",
    steps = {
        { type = "command", command = 'CheckZone "Fixture Vale"' },
        { type = "command", command = "MM 4,0,9" },
        { type = "command", command = 'Pull "a fixture beetle"' },
        { type = "command", command = "LootAll" },
    },
}
local deps, world = require("quests.lib.questworld").make({ onKill = function(_, w) w.lootPending = true end })
local quests = require("eb.quest").bind(deps)
local run = quests.start({ quest = PACK, name = PACK.quest_name }, {})

local trace = {}
for _ = 1, 40 do
    local status, info = quests.step(run)
    trace[#trace + 1] = status
    if status == "need_travel" then print("need_travel " .. info); deps.nav.travelTo(info, { pack = true })
    elseif status == "need_combat" then deps.combat.engage(info)
    elseif status == "need_loot" then deps.economy.lootGrab({})
    elseif status == "complete" or status == "blocked" then break end
    world.tick(5000)
end

DOCS.eq(trace[1], "need_travel", "CheckZone hands the zone change back")
DOCS.eq(trace[#trace], "complete", "the last status")
DOCS.has(table.concat(trace, " "), "need_combat", "a pull is handed back as need_combat")
DOCS.has(table.concat(trace, " "), "need_loot", "a loot pass is handed back as need_loot")
DOCS.has(table.concat(trace, " "), "step_done", "a finished step says step_done")
DOCS.eq(world.did("walk"), 1, "the MM step walked")
