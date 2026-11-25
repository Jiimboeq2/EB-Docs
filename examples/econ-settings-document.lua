-- EB tested example: Write the economy settings
-- econ-settings-document | snippet | topics: items, data, settings
--
-- What it does:  One settings table drives every economy part; whatever you leave out takes a safe default (nothing sold,
--                destroyed or deposited until a rule says so). eco:configure(patch) changes it while EB runs, merging a table one
--                level deep. This is the document a settings file holds.
-- Tested:        The defaults fill the gaps; a live change of the repair threshold takes effect at once.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
