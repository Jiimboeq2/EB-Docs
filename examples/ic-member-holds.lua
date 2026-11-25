-- A member's run: hold, never walk the route
--
-- The same instance run on a box that is not the tank: it holds in the hub until the tank's door takes it in, holds at the camp while the tank walks, and waits to be taken out. It never walks a path step, opens the door or takes the exit itself.
--
-- kind:      snippet
-- expect:    The member's run completes with zero walks, zero door uses and zero exit commands of its own.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.ic
-- id:        ic-member-holds

local INSTANCE = {
    schema = "eb.ic/1", zone = "Fixture Hollow", short = "fixture_hollow",
    hub = { zone = "fixture_docks", door = { actor = "a fixture rift", verb = "enter" } },
    route = {
        { id = "camp", act = "campspot", name = "entry", spot = { 0, 0, -30 }, who = "group" },
        { id = "walk", act = "path", spots = { { 0, 0, 10 }, { 15, 0, 40 } } },
        { id = "exit", act = "zoneout", via = "exit" },
    },
}

-- offline stand-in: this box is a member; the tank's door takes it in at 5 s and its exit takes it out at 60 s
local env, world = require("instances.lib.icworld").make({ tank = false, zonedInAt = 5000, takenOutAt = 60000,
    group = { { id = "is1", role = "tank" } } })
env.loadInstance = function() return INSTANCE end

local runner = require("eb.ic").new(env)
local inst = assert(runner:load("fixture_hollow"))
local ok, why = runner:run(inst, { isTank = false })
for _, l in ipairs(world.lines) do if l:find("holding in the hub", 1, true) then print(l) end end

DOCS.check(ok, "the member's run completes: " .. tostring(why))
DOCS.eq(world.did("walk"), 0, "a member never walks the route")
DOCS.eq(world.did("door"), 0, "a member never opens the door")
DOCS.eq(world.did("zoneExit"), 0, "a member never takes the exit itself")
DOCS.eq(world.did("camp"), 0, "only the tank sets camp spots")
DOCS.eq(world.zone, "fixture_docks", "taken out with the group")
