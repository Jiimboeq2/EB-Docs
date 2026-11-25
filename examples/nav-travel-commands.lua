-- EB tested example: Preview and ride a trip from the console
-- nav-travel-commands | snippet | topics: nav, commands
--
-- What it does:  eb route previews a cross-zone trip without moving; eb transit lists this zone's pads, and with a station rides
--                the pads to it; eb goto starts the trip itself. Each answers at once.
-- Tested:        eb route names the bell hop; eb transit lists both pads; eb goto and eb transit <station> answer "issued".
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: a travel network and two pads as data (in game: EB's own travel and transit data)
local w = DOCS.world()
local NW = require("nav.lib.navworld")
NW.attach(w, { zone = "fixture_hollow" })
NW.transit({ fixture_hollow = { zone = "fixture_hollow", name = "Fixture Hollow", pads = {
    { name = "North Post", loc = { 0, 0, 40 }, network = "griffon", method = "hail", actor = "a fixture tamer",
      dest = { { to = "South Post", cost = 40 } } },
    { name = "South Post", loc = { 0, 0, -40 }, network = "griffon", method = "hail", actor = "a fixture tamer", dest = {} },
} } })
local SHORT = { ["Fixture Hollow"] = "fixture_hollow", ["Fixture Port"] = "fixture_port" }
require("eb.nav_travel").new({
    zoneShort = function() return require("eb.zone").shortName() end,
    connections = function()
        return { bell_travel = { connects_to = { { zone_name = "Fixture Hollow" }, { zone_name = "Fixture Port" } } } }
    end,
    displayToShort = function(name) return SHORT[name] end,
})
local reg = w.registry()
require("eb.nav_register").wire(reg, {})

-- your script
local okR, route = reg:dispatch("eb route fixture_port")
print("route:")
print(route)
local okP, pads = reg:dispatch("eb transit")
local okG, gotoText = reg:dispatch("eb goto fixture_port")
require("eb.nav").stop("the docs example only shows the trip start")

-- check
DOCS.eq(okR, true, "eb route answers")
DOCS.has(route, "bell", "with the hop by bell")
DOCS.eq(okP, true, "eb transit lists the pads")
DOCS.has(pads, "North Post", "the first pad")
DOCS.has(pads, "South Post", "and the second")
DOCS.eq(okG, true, "eb goto was accepted")
DOCS.has(gotoText, "issued", "and answered at once")
