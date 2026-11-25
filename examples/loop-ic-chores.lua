-- EB tested example: Chores at the end of each run
-- loop-ic-chores | snippet | topics: tasks, instances, items
--
-- What it does:  A loop's between option turns chores on (all off by default): each box's saved T.S.E first, then a repair trip
--                when this box's gear is under 90%, then the maintenance cycle. They run once at the END of each run, inside
--                where it ended, and a chore that cannot be done is said and skipped - it never stops the loop.
-- Tested:        After lap 1 the T.S.E ran and the gear at 62% was repaired; maintenance is unwired here, so it is skipped and
--                said.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local INSTANCE = {
    schema = "eb.ic/1", zone = "Fixture Hollow", short = "fixture_hollow",
    route = { { id = "n1", act = "encounter", name = "captain_fixturo" } },
    loop = { rerun_first = false },                   -- the first lap runs where we stand
}
local CAPTAIN = { schema = "eb.ic/1", name = "Captain Fixturo", kind = "named",
                  phases = { { do_ = { { engage = "Captain Fixturo" } } } } }

local env, world = require("instances.lib.icworld").make({ start = "copy", alive = { ["Captain Fixturo"] = 100 },
    upkeep = { gear = 62 } })
env.loadInstance = function() return INSTANCE end
env.loadEncounter = function() return CAPTAIN end

local runner = require("eb.ic").new(env)
local ok, _, report = runner:loop(assert(runner:load("fixture_hollow")),
    { laps = 1, between = { tse = true, repair = true, maintenance = true } })
for _, l in ipairs(world.lines) do if l:find("gear at", 1, true) then print(l) end end

local chores = report.chores[1]
DOCS.check(ok, "the loop ends after its lap")
DOCS.eq(chores.tse, "done", "the saved T.S.E ran on every box")
DOCS.eq(chores.repair, "repaired", "gear under 90%: the repair trip")
DOCS.eq(chores.maintenance, "unwired", "no maintenance runner here: skipped, said, the loop goes on")
DOCS.eq(world.did("hall"), 1, "called to the guild hall once")
