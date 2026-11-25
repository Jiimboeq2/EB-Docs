-- Chores at the end of each run
--
-- A loop's between option turns chores on (all off by default): each box's saved T.S.E first, then a repair trip when this box's gear is under 90%, then the maintenance cycle. They run once at the END of each run, inside where it ended, and a chore that cannot be done is said and skipped - it never stops the loop.
--
-- kind:      snippet
-- expect:    After lap 1 the T.S.E ran and the gear at 62% was repaired; maintenance is unwired here, so it is skipped and said.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.ic
-- id:        loop-ic-chores

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
