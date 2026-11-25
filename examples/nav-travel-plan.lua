-- Plan a trip to another zone
--
-- eb.nav_travel plans cross-zone trips over the game's own travel network (bells, wizard spires, druid rings): preview the hops, and see the fast-travel map refused.
--
-- kind:      snippet
-- expect:    The trip to Fixture Port is one bell hop; the preview names it; asking for the fast-travel map is refused with a reason.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.nav_travel
-- id:        nav-travel-plan

-- offline stand-in for the game (only the docs runner has DOCS; in game the travel data is EB's own)
local w = DOCS.world()
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })
local SHORT = { ["Fixture Hollow"] = "fixture_hollow", ["Fixture Port"] = "fixture_port", ["Fixture Vale"] = "fixture_vale" }

-- your script
local travel = require("eb.nav_travel")
local deps = {                                     -- the travel network as data (in game EB reads its own store)
    zoneShort = function() return require("eb.zone").shortName() end,
    connections = function()
        return { bell_travel = { connects_to = { { zone_name = "Fixture Hollow" }, { zone_name = "Fixture Port" } } },
                 druid_rings_travel = { connects_to = { { zone_name = "Fixture Port" }, { zone_name = "Fixture Vale" } } } }
    end,
    displayToShort = function(name) return SHORT[name] end,
}
travel.new(deps)
local hops = travel.plan(deps, "fixture_hollow", "fixture_vale")
for i, h in ipairs(hops) do print(("hop %d: %s -> %s"):format(i, travel.LABEL[h.network], h.display)) end
for _, line in ipairs(travel.preview("Fixture Port")) do print(line) end
local ok, why = travel.to("Fixture Port", { fastTravelMap = true })
print("fast-travel map: " .. tostring(why))

-- check
DOCS.eq(#hops, 2, "hollow -> port by bell, port -> vale by druid ring")
DOCS.eq(hops[1].network, "bell_travel", "the first hop rides a bell")
DOCS.eq(hops[2].network, "druid_rings_travel", "the second a druid ring")
DOCS.eq(ok, false, "the fast-travel map is never used")
DOCS.has(why, "in-world travel", "and says what EB uses instead")
