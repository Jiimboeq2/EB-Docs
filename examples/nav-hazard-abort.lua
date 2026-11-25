-- Catch health lost out of combat and back out
--
-- Run the walker's hazard watch over your own samples: health falls 15 points in three seconds with no fight on, the watch calls it a hazard, and the way back to the last safe spot is the track walked in reverse.
--
-- kind:      snippet
-- expect:    The losing rule fires; the safe spot is the last dry, unhurt sample at least 6 m back; the way back leads to it.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.nav_hazard
-- id:        nav-hazard-abort

-- offline stand-in for the game (only the docs runner has DOCS; in game a walk samples you twice a second)
local w = DOCS.world()

-- your script
local hazard = require("eb.nav_hazard")
local mon = hazard.new()
local hp = { 100, 100, 100, 100, 100, 98, 94, 90, 85 }          -- health, one sample every 500 ms while walking east
local hz
for i, h in ipairs(hp) do
    local t = 10000 + i * 500
    hazard.sample(mon, { t = t, x = i * 2, y = 0, z = 0, hp = h, swim = false, combat = false, lava = false })
    hz = hz or hazard.check(mon, t, { lethalZone = false })
end
print("hazard: " .. tostring(hz and hz.what))
local losing, was = hazard.losing(mon.track, 10000 + #hp * 500, hp[#hp])
local safe, k = hazard.safeSpot(mon, hz.x, hz.z, hz.was)
local back = hazard.wayBack(mon, k)
print(("back out to %.0f,%.0f over %d points"):format(safe.x, safe.z, #back))

-- check
DOCS.check(hz ~= nil, "the watch called a hazard")
DOCS.eq(losing, true, "the losing rule on its own agrees")
DOCS.eq(was, 100, "the most health this stretch held")
DOCS.check(hz.x - safe.x >= hazard.BACK, "the safe spot is at least 6 m back")
DOCS.check(safe.hp >= hz.was - 2, "and you were unhurt there")
DOCS.eq(back[#back].x, safe.x, "the way back ends at the safe spot")
