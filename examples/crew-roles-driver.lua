-- EB tested example: Who drives the group
-- crew-roles-driver | snippet | topics: crew, instances
--
-- What it does:  The tank runs the route and zones the group in; group.role() and group.amDriver() say who that is.
-- Tested:        The guardian is the tank and the driver; the templar is the healer and hands the drive to the tank.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
