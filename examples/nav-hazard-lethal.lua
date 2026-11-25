-- Never swim where the liquid kills
--
-- The zones whose liquid kills are a list you can set; swimming in one is a hazard at once, unless the walk says it has to go in (a quest step) with allowLethal.
--
-- kind:      snippet
-- expect:    Swimming in a listed zone is a hazard; the same sample with allowLethal is not; another zone is not.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.nav_hazard
-- id:        nav-hazard-lethal

-- offline stand-in for the game (only the docs runner has DOCS; in game a walk samples you twice a second)
local w = DOCS.world()

-- your script
local hazard = require("eb.nav_hazard")
hazard.setLethalZones("fixture_magma, fixture_cinders")
local function swimSample(ctx)
    local mon = hazard.new()
    hazard.sample(mon, { t = 1000, x = 5, y = -2, z = 5, hp = 100, swim = true, combat = false, lava = false })
    return hazard.check(mon, 1000, ctx)
end
local inLethal = swimSample({ lethalZone = hazard.lethalZone("fixture_magma") })
local allowed = swimSample({ lethalZone = true, allowLethal = true })      -- a quest step that has to go in
local safeZone = swimSample({ lethalZone = hazard.lethalZone("fixture_hollow") })
print("hazard in fixture_magma: " .. tostring(inLethal ~= nil))

-- check
DOCS.eq(hazard.lethalZone("fixture_cinders"), true, "the list was set")
DOCS.check(inLethal ~= nil and inLethal.lethal == true, "swimming in a lethal zone is a hazard")
DOCS.eq(allowed, nil, "unless the walk allows it")
DOCS.eq(safeZone, nil, "swimming elsewhere is fine")
