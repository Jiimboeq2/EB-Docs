-- Ride the zone's own transit
--
-- eb.transit plans hops over a zone's griffon / flight-path pads; each hop is walked to on the mesh, then the pad is opened. Never fast travel.
--
-- kind:      snippet
-- expect:    The preview is one griffon hop; the walk reaches the North Post on the mesh; with no tamer wired the ride stops and says why.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.transit, eb.transit_ride, eb.nav
-- id:        nav-transit-pads

-- offline stand-in for the game (only the docs runner has DOCS; in game the transit data is EB's own)
local w = DOCS.world({ me = { x = -20, y = 0, z = 0 } })
local NW = require("nav.lib.navworld")
NW.attach(w, { zone = "fixture_hollow" })
NW.transit({ fixture_hollow = { version = 1, zone = "fixture_hollow", name = "Fixture Hollow", pads = {
    { name = "North Post", loc = { 0, 0, 0 }, network = "griffon", method = "hail", actor = "a fixture tamer",
      reply = "I would like to travel.", dest = { { to = "South Post", land = { 100, 0, 100 }, cost = 40 } } },
    { name = "South Post", loc = { 100, 0, 100 }, network = "griffon", method = "hail", actor = "a fixture tamer",
      dest = { { to = "North Post", land = { 0, 0, 0 }, cost = 40 } } } } } })

-- your script
local transit = require("eb.transit")
local ride = require("eb.transit_ride")
local nav = require("eb.nav")

for _, line in ipairs(transit.preview("South Post", { zone = "fixture_hollow", x = -20, y = 0, z = 0 })) do print(line) end
local pads = transit.padsForZone("fixture_hollow")

local rider = ride.new({ nav = nav })               -- in game EB wires the tamer and the station map for you
local walked, why = w.task(function() return rider.walkTo({ name = pads[1].name, loc = { x = 0, y = 0, z = 0 } }) end)
local opened, owhy = rider.open({ name = "North Post", loc = { x = 0, y = 0, z = 0 }, method = "hail", actor = "a fixture tamer" })
print("opened: " .. tostring(opened) .. " - " .. tostring(owhy))

-- check
DOCS.eq(#pads, 2, "two pads in this zone")
DOCS.eq(walked, true, "walked to the pad on the mesh (" .. tostring(why) .. ")")
DOCS.check(NW.flat(w, 0, 0) <= ride.ARRIVE, "standing at the pad")
DOCS.eq(opened, false, "nothing to hail with offline")
DOCS.has(owhy, "reached North Post", "the stop names where it got to")
DOCS.check(ride.assertMeshOnly("eq2execute hail") == true, "a hail is allowed")
DOCS.eq((ride.assertMeshOnly("smp pon pon_teleport")), false, "a fast-travel command is refused in a transit hop")
