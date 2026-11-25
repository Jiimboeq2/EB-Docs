-- Write the economy settings
--
-- One settings table drives every economy part; whatever you leave out takes a safe default (nothing sold, destroyed or deposited until a rule says so). eco:configure(patch) changes it while EB runs, merging a table one level deep. This is the document a settings file holds.
--
-- kind:      snippet
-- expect:    The defaults fill the gaps; a live change of the repair threshold takes effect at once.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy, eb.economy.rules
-- id:        econ-settings-document

-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world()

-- your script: the settings (every key optional)
local settings = {
    bags    = { fullThreshold = 4 },                                    -- 4 or fewer free slots = full
    protect = { names = { ["fixture charm"] = true } },                 -- never sold / destroyed / deposited
    depot   = { keep = { ["fixture arrow"] = true } },                  -- never deposited
    vendor  = { sellList = { "Fixture Pelt" }, junkTiers = { Junk = true }, repairBelowPct = 40,
                restockPresets = { food = { { name = "Fixture Bread", qty = 20 } } } },
    loot    = { method = "nbg", space = 2, rules = { ["fixture gem"] = "need" } },
    broker  = { undercut = 5, friendsFloorCopper = 1000, priceDefaults = { ["fixture ore"] = 1200 } },
    bank    = { keepFree = 2 },
    mail    = { keepFree = 1 },
    craft   = { commissions = { enabled = false } },
}
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me, cfg = settings })
local cfg = eco.env.cfg
DOCS.eq(cfg.bags.fullThreshold, 4, "yours")
DOCS.eq(cfg.vendor.sellJunk, false, "a default kept: junk selling stays off")
DOCS.eq(cfg.broker.beatAll, false, "a default kept")

eco:configure({ vendor = { repairBelowPct = 25 } })                     -- a live change
print("repair below " .. cfg.vendor.repairBelowPct .. "%")

-- check
DOCS.eq(cfg.vendor.repairBelowPct, 25, "changed")
DOCS.eq(cfg.vendor.sellList[1], "Fixture Pelt", "the rest of the vendor block is untouched")
DOCS.eq(eco:contract().bagsFull({ bagsFreeSlots = 4 }), true, "4 free is full at this threshold")
