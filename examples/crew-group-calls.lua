-- Call the group back, evacuate, read the group
--
-- eb.relay.group's calls over a real relay: send a line, read the group from the world snapshot, record a member's mark, call stuck members back (catchup) and evacuate (evac); then leave the relay.
--
-- kind:      snippet
-- expect:    The healer's box hears the pause, the catch-up order and the evacuation order; the group lists the healer with its role; leave marks the relay as no longer joined.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.relay.group, eb.relay
-- id:        crew-group-calls

-- offline stand-in: an in-memory relay between two boxes, and the group as the world snapshot reports it
local bus = require("eb.relay.events").bus()
local world = { snapshot = function()
    return { name = "Tankard", zone = "a_test_hall", group = { count = 2, members = {
        { name = "Mendwell", zone = "a_test_hall", subclass = "templar" } } } }
end }

-- your script
local Relay = require("eb.relay")
local Group = require("eb.relay.group")
local tank = Relay.new({ box = "is1", name = "Tankard", subclass = "guardian", transport = bus.box("is1") })
local healer = Relay.new({ box = "is2", name = "Mendwell", subclass = "templar", transport = bus.box("is2") })
local heard, notes = {}, {}
healer.onLocal(function(line) heard[#heard + 1] = line end)
tank.note(function(text) notes[#notes + 1] = text end)        -- lines the console shows but does not act on
tank.join(); healer.join()

local G = Group.new({ relay = tank, world = world, me = { box = "is1", name = "Tankard", subclass = "guardian" },
    clock = function() return 0 end })
G.send("others", "eb pause")
local back = G.catchup("is2")                 -- the first answer to a member who fell behind
local out = G.evac()                          -- the evacuation chain, then a totem - only ever by spell
local gs = G.groupState()
G.recordMark("Mendwell", "door")
print(("heard: %s; %s is the %s"):format(table.concat(heard, " | "), gs.members[1].name, gs.members[1].role))

tank.leave()                                  -- in game: the transport leaves the relay group join() joined

-- check
DOCS.eq(back, "working", "the catch-up order went out")
DOCS.eq(out, "working", "the evacuation order went out")
DOCS.eq(gs.leader, "Tankard", "the leader is this box's character")
DOCS.eq(gs.members[1].role, "healer", "a templar is the healer")
DOCS.eq(tank.joined, false, "leave marks the relay as no longer joined")
DOCS.eq(#notes, 0, "nothing needed a console note")
