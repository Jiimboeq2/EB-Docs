-- Keep walks out of a bad spot
--
-- Blacklist the spot you stand on (a hole walks fall into, a corner they wedge in) so routes go round it; a greenlight on it lifts the blacklist again.
--
-- kind:      snippet
-- expect:    The blacklist circle is kept for this zone and becomes an avoid circle; a greenlight on the same spot lifts it.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.nav, eb.nav_places
-- id:        nav-blacklist-spot

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { x = 12, y = 0, z = -4 } })
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })

-- your script
local nav = require("eb.nav")
local places = require("eb.nav_places")
local ok, text = nav.cmd({ "bl" })                       -- where you stand, the default radius (places.BL_R)
print(text)
local avoid = places.avoidCircles("fixture_hollow")      -- what the walker routes round from the next walk on
nav.cmd({ "gl" })                                        -- "no, this spot is fine after all"
local after = places.avoidCircles("fixture_hollow")

-- check
DOCS.eq(ok, true, "blacklisted")
DOCS.eq(#places.listBlacklist("fixture_hollow"), 1, "one circle kept for this zone")
DOCS.eq(#avoid, 1, "an avoid circle while it is not greenlit")
DOCS.eq(places.isGreenlit("fixture_hollow", 12, 0, -4), true, "the greenlight covers it")
DOCS.eq(#after, 0, "a greenlight beats the blacklist")
