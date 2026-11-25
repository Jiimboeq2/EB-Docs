-- EB tested example: Save a spot and walk back to it
-- nav-saved-spot | snippet | topics: nav, helpers
--
-- What it does:  Save where you stand under a name with eb.nav.cmd, walk away, then walk back by name with eb.nav.gotoNamed.
-- Tested:        "camp" is saved at the start; after a walk east the box walks back to it by name.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { x = 5, y = 0, z = 5 } })
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })

-- your script
local nav = require("eb.nav")
local ok, text = nav.cmd({ "save", "camp" })            -- a private spot (mark = one shared with your crew)
print(text)
local away = w.task(function() return nav.goPoint(40, 0, 5) end)
local back, why = w.task(function() return nav.gotoNamed("camp") end)
print(("back at camp: %s, %.1f m off"):format(tostring(back), math.sqrt((w.self.x - 5) ^ 2 + (w.self.z - 5) ^ 2)))
local zone, x, y, z = require("eb.nav_marks").resolve("camp")

-- check
DOCS.eq(ok, true, "saved")
DOCS.eq(away, true, "walked away")
DOCS.eq(back, true, "walked back by name (" .. tostring(why) .. ")")
DOCS.eq(zone, "fixture_hollow", "the spot belongs to this zone")
DOCS.near(x, 5, 1e-6, "saved x"); DOCS.near(z, 5, 1e-6, "saved z")
