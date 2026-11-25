-- EB tested example: Stop a quest run at once
-- quest-stop-flag | snippet | topics: quests, helpers
--
-- What it does:  deps.shouldStop is asked first on every step: when it answers true the step returns blocked, "stopped by
--                request", before touching anything. Because the runner never waits, a stop takes effect on the very next tick.
-- Tested:        The first tick walks; after the stop flag goes up the next tick is blocked and nothing else moves.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
