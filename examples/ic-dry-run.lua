-- Dry-run an instance file
--
-- Run an instance with dry = true: every step reports what it would do and nothing is sent to the game - no walk, no door, no pull. Use it to check a new file before a real run.
--
-- kind:      snippet
-- expect:    The dry run completes, prints its would-do lines, and the world records no movement and no fight.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.ic
-- id:        ic-dry-run

local INSTANCE = {
    schema = "eb.ic/1", zone = "Fixture Hollow", short = "fixture_hollow",
    hub = { zone = "fixture_docks", door = { actor = "a fixture rift", verb = "enter" } },
    route = {
        { id = "walk", act = "path", spots = { { 0, 0, 10 }, { 15, 0, 40 } } },
        { id = "n1", act = "encounter", name = "captain_fixturo" },
        { id = "exit", act = "zoneout", via = "exit" },
    },
}
local CAPTAIN = { schema = "eb.ic/1", name = "Captain Fixturo", kind = "named",
                  phases = { { id = "pull", do_ = { { target = { "Captain Fixturo" } }, { engage = "Captain Fixturo" } } } } }

local env, world = require("instances.lib.icworld").make({ alive = { ["Captain Fixturo"] = 100 } })
env.loadInstance = function() return INSTANCE end
env.loadEncounter = function() return CAPTAIN end

local runner = require("eb.ic").new(env)
local ok = runner:run(assert(runner:load("fixture_hollow")), { dry = true })
for _, l in ipairs(world.lines) do if l:find("would", 1, true) then print(l) end end

DOCS.check(ok, "the dry run completes")
DOCS.eq(world.did("walk") + world.did("door") + world.did("engage") + world.did("travel"), 0, "nothing was sent")
DOCS.check(world.said("[DRY RUN]"), "the header says it is a dry run")
