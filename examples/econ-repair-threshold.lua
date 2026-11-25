-- Repair only when the gear needs it
--
-- eco.vendor:repair() reads the worst condition of your worn gear and walks the mender's window only when it is at or under cfg.vendor.repairBelowPct (40 by default); { force = true } repairs anyway. The same call the brain makes after a run or a death.
--
-- kind:      snippet
-- expect:    At 90% nothing opens; at 30% the mender repairs everything back to 100%.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.vendor
-- id:        econ-repair-threshold

-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({ worn = { chest = { name = "Fixture Vest", condition = 90 },
                                legs = { name = "Fixture Leggings", condition = 95 } } })
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me })

-- your script
local function repairNow()
    local s
    for _ = 1, 20 do
        s = eco.vendor:repair()
        if s ~= "working" then return s end
    end
    return s
end

DOCS.eq(eco.vendor:worstCondition(), 90, "the worst piece is at 90%")
DOCS.eq(repairNow(), "done", "above the threshold: done without a trip")
DOCS.eq(#W.log, 0, "no window was opened")

W.worn.legs.condition = 30                     -- a hard fight later
DOCS.eq(repairNow(), "done", "under the threshold: repaired")
print("repaired: " .. W.worn.legs.condition)

-- check
DOCS.eq(W.worn.legs.condition, 100, "the legs are mended")
DOCS.eq(W.log[#W.log], "repair all", "the mender's repair-all ran")
