-- Who drives the group
--
-- The tank runs the route and zones the group in; group.role() and group.amDriver() say who that is.
--
-- kind:      snippet
-- expect:    The guardian is the tank and the driver; the templar is the healer and hands the drive to the tank.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.relay.group, eb.relay, eb.relay.events
-- id:        crew-roles-driver

-- offline stand-in: an offline relay bus and the world snapshot of each box
local bus = require("eb.relay.events").bus()
local function worldOf(class, others)
    return { snapshot = function() return { name = "Me", class = class, group = { count = #others, members = others } } end }
end
local party = {
    { name = "Tankard", zone = "a_test_hall", subclass = "guardian" },
    { name = "Mendwell", zone = "a_test_hall", subclass = "templar" },
}

-- your script
local Relay, Group = require("eb.relay"), require("eb.relay.group")
local tankRelay = Relay.new({ box = "is1", name = "Tankard", subclass = "guardian", transport = bus.box("is1") })
local healRelay = Relay.new({ box = "is2", name = "Mendwell", subclass = "templar", transport = bus.box("is2") })
local drives = {}
tankRelay.onLocal(function(line) drives[#drives + 1] = line end)
tankRelay.join(); healRelay.join()
local tank = Group.new({ relay = tankRelay, world = worldOf("guardian", { party[2] }) })
local heal = Group.new({ relay = healRelay, world = worldOf("templar", { party[1] }) })
print(("guardian: %s driver=%s | templar: %s driver=%s"):format(tank.role(), tostring(tank.amDriver()),
    heal.role(), tostring(heal.amDriver())))
local handed = heal.handoffToTank("a_test_hall")       -- the healer asks the tank to drive

-- check
DOCS.eq(tank.role(), "tank", "a fighter is the tank")
DOCS.eq(heal.role(), "healer", "a priest is the healer")
DOCS.check(tank.amDriver() and not heal.amDriver(), "only the tank drives")
DOCS.eq(handed, "ok", "the drive was handed over")
DOCS.has(drives[1], "a_test_hall", "the tank's box got the hand-over line")
DOCS.eq(Group.roleOf("wizard"), "member", "everyone else is a member")
