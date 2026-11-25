-- EB tested example: Keep walks out of a bad spot
-- nav-blacklist-spot | snippet | topics: nav, helpers
--
-- What it does:  Blacklist the spot you stand on (a hole walks fall into, a corner they wedge in) so routes go round it; a
--                greenlight on it lifts the blacklist again.
-- Tested:        The blacklist circle is kept for this zone and becomes an avoid circle; a greenlight on the same spot lifts it.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
