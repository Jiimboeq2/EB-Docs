-- A goal in lava becomes its shore
--
-- Ask for a point that stands in lava: the walker never walks into it; it walks to the nearest dry ground instead and says so.
--
-- kind:      snippet
-- expect:    inLava reads true for the goal; the walk reports the shore it took and ends on dry ground short of the pool.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.nav, eb.nav_hazard
-- id:        nav-lava-goal-shore

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
