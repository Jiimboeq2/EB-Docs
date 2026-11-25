-- EB tested example: Sell a list of items at a merchant
-- econ-vendor-sell-sweep | snippet | topics: items, helpers
--
-- What it does:  eco.vendor:sell() opens the merchant in reach, sells every bag item your sell list names, skips anything
--                protected, closes the window and writes a ledger line per sale. Call it once a tick until it stops answering
--                "working".
-- Tested:        The three pelts are sold (60 copper), the protected charm stays in the bags, and the ledger counts them.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game's windows (only the docs runner has it; in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({ bags = {
    { name = "Fixture Pelt", qty = 3, value = 20 },
    { name = "Fixture Charm", qty = 1, value = 500 },
    { name = "Fixture Lantern", qty = 1, value = 90 },
} })

-- your script
local eco = require("eb.economy").new({
    drive = Fake.drive(W), me = W.me, wallNow = function() return 1763000000 end,
    cfg = {
        vendor = { sellList = { "Fixture Pelt", "Fixture Charm" } },       -- exact names this sweep may sell
        protect = { names = { ["fixture charm"] = true } },               -- never sold, whatever a list says
    },
})
local status
for _ = 1, 20 do                       -- the brain calls it once a tick with the same arguments
    status = eco.vendor:sell()
    if status ~= "working" then break end
end
print("sell: " .. status)
print(eco.ledger:status().text)

-- check
DOCS.eq(status, "done", "the sweep finished")
DOCS.eq(W.merchant.coin, 60, "three pelts at 20 copper")
local charm = false
for _, it in ipairs(W.bags) do if it.name == "Fixture Charm" then charm = true end end
DOCS.check(charm, "the protected charm was not sold")
DOCS.has(eco.ledger:status().text, "3 sold", "the sale is in the ledger (counted in items)")
DOCS.check(not W.merchant.open, "the merchant window was closed")
