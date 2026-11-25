-- The tank zones the group in
--
-- Every box reaches the hub on its own; the tank waits for the whole group there, re-sends a member that is still elsewhere its own travel, walks the hub approach alone and uses the door once for everyone.
--
-- kind:      snippet
-- expect:    The straggler is sent its own travel once, the door is used once with who = group, and every member ends up inside.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.ic
-- id:        ic-tank-zones-group-in

local INSTANCE = {
    schema = "eb.ic/1", zone = "Fixture Hollow", short = "fixture_hollow",
    hub = { zone = "fixture_docks", difficulty = "[Heroic I]",
            approach = { { 10, 0, 10 } }, entrance = { loc = { 10, 0, 10 }, tolerance = 8 },
            door = { actor = "a fixture rift", verb = "enter" } },
    route = { { id = "hold", act = "wait", seconds = 1 } },
}

-- offline stand-in: a three-box group; the healer's box is still in another zone
local env, world = require("instances.lib.icworld").make({
    group = { { id = "is2", role = "healer", zone = "fixture_market" }, { id = "is3", role = "dps" } } })
env.loadInstance = function() return INSTANCE end

local runner = require("eb.ic").new(env)
local inst = assert(runner:load("fixture_hollow"))
local ctx = runner:newCtx(inst, {})              -- the run state: role, group, options
local ok, why = runner:zoneIn(ctx)               -- the entry alone (runner:run starts with it)
for _, l in ipairs(world.lines) do if l:find("not everyone", 1, true) then print(l) end end

DOCS.check(ok, "zoned in: " .. tostring(why))
DOCS.eq(world.did("sendTravel"), 1, "the straggler was re-sent its OWN travel, once")
local _, door = world.first("door")
DOCS.eq(door[2], "a fixture rift", "the tank used the door")
DOCS.eq(door[4], "group", "one door use takes the whole group")
DOCS.eq(world.did("door"), 1, "nobody else used it")
for _, m in ipairs(env.brain.group()) do DOCS.eq(m.zone, "fixture_hollow", "inside: " .. m.id) end
