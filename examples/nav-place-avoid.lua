-- EB tested example: Keep every walk out of a bad spot
-- nav-place-avoid | snippet | topics: nav, helpers
--
-- What it does:  Blacklist a circle in a zone so routes go round it, greenlight a spot that must stay reachable, and push the
--                circles into the mesh service for one walk - the way a walk does it once, at its start.
-- Tested:        Two circles are blacklisted; the one under a greenlight is lifted; one circle reaches the mesh service.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: EB's mesh extension and EB's nav data kept in memory (in game: the mesh store, this PC's files)
local w = DOCS.world()
require("nav.lib.ebnav").attach(w, { zone = "fixture_hollow" })
require("eb.nav_store").configure({ root = "store", localRoot = "local", fs = require("ebkit.files").memory({}) })

-- your script
local places, navd = require("eb.nav_places"), require("eb.navd")
places.blacklist("fixture_hollow", 30, 0, 30, { r = 5, note = "a hole the walk falls into" })
places.blacklist("fixture_hollow", 60, 0, 10, { r = 4 })
places.greenlight("fixture_hollow", 60, 0, 10, { r = 3 })            -- this spot has to stay reachable
local inForce = places.avoidCircles("fixture_hollow")
navd.avoid.zoneChanged("fixture_hollow")
local pushed = places.seedAvoids("fixture_hollow", navd, 90, 0, 90)  -- the walk's goal is 90, 0, 90
print("circles pushed for the walk: " .. pushed)
local held = navd.avoid.temps("fixture_hollow")
places.removeBlacklist("fixture_hollow", 30, 30)

-- check
DOCS.eq(#places.listBlacklist("fixture_hollow"), 1, "one blacklist circle left after the removal")
DOCS.eq(#inForce, 1, "the greenlit circle was not in force")
DOCS.eq(inForce[1].x, 30, "the hole's circle was")
DOCS.eq(pushed, 1, "one circle went to the mesh service")
DOCS.eq(#held, 1, "and it holds it for this walk")
DOCS.eq(places.isGreenlit("fixture_hollow", 60, 0, 10), true, "the greenlit spot")
