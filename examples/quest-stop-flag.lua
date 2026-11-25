-- Stop a quest run at once
--
-- deps.shouldStop is asked first on every step: when it answers true the step returns blocked, "stopped by request", before touching anything. Because the runner never waits, a stop takes effect on the very next tick.
--
-- kind:      snippet
-- expect:    The first tick walks; after the stop flag goes up the next tick is blocked and nothing else moves.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.quest
-- id:        quest-stop-flag

local stop = false
local deps, world = require("quests.lib.questworld").make()
deps.shouldStop = function() return stop end              -- e.g. your own "eb stop" handling
local quests = require("eb.quest").bind(deps)
local run = quests.start({ quest = { schema = "eb-quest/1", quest_name = "Fixture Patrol", steps = {
    { type = "command", command = "MM 1,0,1" }, { type = "command", command = "MM 2,0,2" } } },
    name = "Fixture Patrol" }, {})

local first = quests.step(run)
stop = true
local st, why = quests.step(run)
print(why)

DOCS.eq(first, "step_done", "the first step ran")
DOCS.eq(st, "blocked", "the stop is honoured on the next tick")
DOCS.eq(why, "stopped by request", "with that reason")
DOCS.eq(world.did("walk"), 1, "nothing moved after the stop")
