-- EB tested example: The T.S.E at the zone's end, inside
-- tse-at-zone-end | snippet | topics: instances, tasks
--
-- What it does:  Looping one zone, the chores run once at the END of each run, inside the copy where the run ended: every box
--                runs its saved T.S.E pass first, then a repair trip if gear is low. Only then does the tank wait out the timer,
--                leave by the exit and reset. Here the T.S.E call records the zone it ran in.
-- Tested:        The T.S.E runs once, for every box, while the tank is still inside the cleared copy; the loop then ends after
--                its one lap.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local INSTANCE = {
    schema = "eb.ic/1", zone = "Fixture Hollow", short = "fixture_hollow",
    hub = { zone = "fixture_docks", entrance = { loc = { 0, 0, 0 }, tolerance = 8 },
            door = { actor = "a fixture rift", verb = "enter" } },
    route = { { id = "walk", act = "path", spots = { { 0, 0, 10 } } } },    -- the run ends inside: no zoneout step
    loop = { rerun_first = false },
}

-- offline stand-in for the game: the upkeep interface's T.S.E records where it was asked
local env, world = require("instances.lib.icworld").make({ start = "copy", upkeep = { gear = 100 },
    group = { { id = "is2", role = "healer" } } })
env.loadInstance = function() return INSTANCE end
local tseZone, tseScope
local tse = env.upkeep.tse
env.upkeep.tse = function(scope) tseZone, tseScope = env.nav.zone(), scope; return tse(scope) end

-- your script: one lap, the T.S.E and repair chores ticked
local runner = require("eb.ic").new(env)
local inst = assert(runner:load("fixture_hollow"))
local ok, why, report = runner:loop(inst, { laps = 1, between = { tse = true, repair = true } })
print(("T.S.E ran in %s for %s"):format(tostring(tseZone), tostring(tseScope)))

-- check
DOCS.check(ok, "the loop ends cleanly: " .. tostring(why))
DOCS.eq(world.did("tse"), 1, "one T.S.E pass")
DOCS.eq(tseZone, "fixture_hollow", "inside the copy where the run ended")
DOCS.eq(tseScope, "all", "every box runs its own")
DOCS.eq(report.chores[1].tse, "done", "the chore report says it ran and ended")
DOCS.eq(report.chores[1].repair, "not needed", "gear at 100%: no repair trip")
