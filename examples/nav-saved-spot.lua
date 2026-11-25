-- Save a spot and walk back to it
--
-- Save where you stand under a name with eb.nav.cmd, walk away, then walk back by name with eb.nav.gotoNamed.
--
-- kind:      snippet
-- expect:    "camp" is saved at the start; after a walk east the box walks back to it by name.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.nav, eb.nav_marks
-- id:        nav-saved-spot

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
