-- Read a zone's pads and plan a pad trip
--
-- EB's pad data per zone: the pads, their networks, what each offers, the nearest one; then the pad graph - the fewest hops from where you stand to a station, the time it takes, and the flights that cross a zone line.
--
-- kind:      snippet
-- expect:    Two griffon hops reach the far tower; one flight crosses into the next zone; the rides add up to 75 s.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.transit_data, eb.transit_graph, eb.transit_store, eb.transit
-- id:        nav-transit-graph

-- offline stand-in: one zone's pad file as data (in game: EB's own transit data, one file per zone)
local w = DOCS.world()
local NW = require("nav.lib.navworld")
NW.attach(w, { zone = "fixture_hollow" })
NW.transit({ fixture_hollow = { zone = "fixture_hollow", name = "Fixture Hollow", pads = {
    { name = "Fixture Landing", loc = { 0, 0, 0 }, network = "griffon", method = "hail", actor = "a fixture tamer",
      dest = { { to = "Fixture Ridge", land = { 300, 20, 0 }, cost = 30 } } },
    { name = "Fixture Ridge", loc = { 300, 20, 0 }, network = "griffon", method = "hail", actor = "a fixture tamer",
      dest = { { to = "Fixture Tower", land = { 600, 40, 0 }, cost = 45 }, { to = "Fixture Gate", cost = 60 } } },
    { name = "Fixture Tower", loc = { 600, 40, 0 }, network = "griffon", method = "hail", actor = "a fixture tamer",
      dest = {} },
} }, fixture_vale = { zone = "fixture_vale", name = "Fixture Vale", pads = {
    { name = "Fixture Gate", loc = { 10, 0, 10 }, network = "griffon", method = "hail", dest = {} },
} } })

-- your script
local data, graph = require("eb.transit_data"), require("eb.transit_graph")
local pads = data.forZone("fixture_hollow")
local near = data.nearest(data.forNetwork("fixture_hollow", "griffon"), 5, 0, 5)
local offers = data.destinations("fixture_hollow", "griffon")
local g = graph.build()
local plan = graph.planInZone(g, "fixture_hollow", 5, 0, 5, "Fixture Tower")
local crossing = graph.crossZoneEdges(g)
print(("plan: %s -> Fixture Tower (%d hops, %d s)"):format(plan.start.name, #plan.hops, graph.cost(plan.hops)))
require("eb.transit").resetGraph()            -- after new pad data: the next trip builds its graph again

-- check
DOCS.eq(#pads, 3, "three pads in the zone")
DOCS.eq(near.name, "Fixture Landing", "the nearest pad to stand at")
DOCS.eq(#offers, 3, "the zone's griffons offer three stations")
DOCS.eq(#plan.hops, 2, "landing -> ridge -> tower")
DOCS.eq(graph.cost(plan.hops), 75, "30 s + 45 s")
DOCS.eq(#crossing, 1, "one flight crosses a zone line")
DOCS.eq(crossing[1].toZone, "fixture_vale", "into the vale")
