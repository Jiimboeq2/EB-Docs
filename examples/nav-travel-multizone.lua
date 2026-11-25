-- Plan a multi-zone trip by bell and spire, by your side
--
-- A trip of several hops over the game's own networks: a bell to the steppe, then a wizard spire to the isle. City bells never cross sides, so a good character's trip to an evil city is left out and the planner says why.
--
-- kind:      snippet
-- expect:    Two hops (bell, spire) to the isle; the evil city has no route for a character bound in a good city.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.nav_travel, eb.nav_side
-- id:        nav-travel-multizone

-- offline stand-in: the travel network and the cities' sides as data (in game: EB's own travel data)
local w = DOCS.world()
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })
local SHORT = { ["Fixture Hollow"] = "fixture_hollow", ["Fixture Keep"] = "fixture_keep",
    ["Fixture Gloom"] = "fixture_gloom", ["Fixture Steppe"] = "fixture_steppe", ["Fixture Isle"] = "fixture_isle" }
require("eb.nav_side").load({ zones = { ["Fixture Keep"] = "good", ["Fixture Gloom"] = "evil" } }, true)

-- your script
local travel = require("eb.nav_travel")
local deps = {
    connections = function()
        return {
            bell_travel = { connects_to = { { zone_name = "Fixture Hollow" }, { zone_name = "Fixture Keep" },
                                            { zone_name = "Fixture Gloom" }, { zone_name = "Fixture Steppe" } } },
            wizard_spires_travel = { connects_to = { { zone_name = "Fixture Steppe" }, { zone_name = "Fixture Isle" } } },
        }
    end,
    displayToShort = function(name) return SHORT[name] end,
    bind = function() return "Fixture Keep" end,          -- where this character is bound: a good city
}
local mySide, from = travel.side(deps)
local hops = travel.plan(deps, "fixture_hollow", "fixture_isle")
for i, h in ipairs(hops) do print(("hop %d: %s -> %s"):format(i, travel.LABEL[h.network], h.display)) end
local none, why = travel.plan(deps, "fixture_hollow", "fixture_gloom")
print("to the evil city: " .. tostring(why))

-- check
DOCS.eq(mySide, "good", "the side comes from the bind city (" .. tostring(from) .. ")")
DOCS.eq(#hops, 2, "two hops")
DOCS.eq(hops[1].network, "bell_travel", "a bell to the steppe first")
DOCS.eq(hops[2].network, "wizard_spires_travel", "then a wizard spire")
DOCS.eq(travel.shortOf(deps, "Fixture Isle"), "fixture_isle", "display names resolve to short names")
DOCS.eq(none, nil, "no route into the other side's city")
DOCS.has(why, "left out for this character's side", "and the planner says which hops it left out")
