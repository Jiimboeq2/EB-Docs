-- Death in an instance: revive, walk back, pull again
--
-- The tank dies on the first pull of a named. The runner waits for the group to be revived, walks back from the nearest positioned step before the fight (skipping loot), and runs the encounter again. Nothing is ever moved any other way.
--
-- kind:      snippet
-- expect:    The second pull kills the named, the catch-up walk re-walks the path step, and the run completes.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.ic
-- id:        ic-death-recovery

local INSTANCE = {
    schema = "eb.ic/1", zone = "Fixture Hollow", short = "fixture_hollow",
    route = {
        { id = "camp", act = "campspot", name = "entry", spot = { 0, 0, -30 }, who = "group" },
        { id = "walk", act = "path", spots = { { 0, 0, 10 }, { 15, 0, 40 } } },
        { id = "n1", act = "encounter", name = "captain_fixturo" },
    },
}
local CAPTAIN = { schema = "eb.ic/1", name = "Captain Fixturo", kind = "named",
                  phases = { { id = "pull", do_ = { { engage = "Captain Fixturo" } } } } }

-- offline stand-in: the first pull of the captain kills the tank
local env, world = require("instances.lib.icworld").make({ start = "copy",
    alive = { ["Captain Fixturo"] = 100 }, dieOnFirst = "Captain Fixturo" })
env.loadInstance = function() return INSTANCE end
env.loadEncounter = function() return CAPTAIN end

local runner = require("eb.ic").new(env)
local inst = assert(runner:load("fixture_hollow"))
local ok, _, report = runner:run(inst)
for _, l in ipairs(world.lines) do if l:find("RECOVERY", 1, true) then print(l) end end

DOCS.check(ok, "the run completes after the recovery")
DOCS.eq(report.verdicts.n1, "killed", "the second pull kills the named")
DOCS.eq(world.attempts["Captain Fixturo"], 2, "two pulls: the wipe, then the kill")
DOCS.eq(world.did("revived"), 1, "the runner waited for the group to be revived")
DOCS.eq(world.did("walk"), 4, "the path step was walked again (2 waypoints, twice)")
