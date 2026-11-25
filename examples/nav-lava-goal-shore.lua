-- EB tested example: A goal in lava becomes its shore
-- nav-lava-goal-shore | snippet | topics: nav, helpers
--
-- What it does:  Ask for a point that stands in lava: the walker never walks into it; it walks to the nearest dry ground instead
--                and says so.
-- Tested:        inLava reads true for the goal; the walk reports the shore it took and ends on dry ground short of the pool.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { x = 0, y = 0, z = 0 } })
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow", lava = { { 30, -10, 50, 10 } } })

-- your script
local nav = require("eb.nav")
local hazard = require("eb.nav_hazard")
print("the goal is lava: " .. tostring(hazard.inLava(40, 0, 0)))
local said = {}
local ok = w.task(function()
    return nav.goPoint(40, 0, 0, { onStatus = function(s) said[#said + 1] = s end })
end)
print(said[1])

-- check
DOCS.eq(hazard.inLava(40, 0, 0), true, "the goal reads as lava")
DOCS.eq(ok, true, "the walk to the shore arrived")
DOCS.has(said[1], "walking to its shore", "it said what it did")
DOCS.check(w.self.x < 30, "it stopped on dry ground, short of the pool")
DOCS.eq(hazard.inLava(w.self.x, 0, w.self.z), false, "where it stands is not lava")
