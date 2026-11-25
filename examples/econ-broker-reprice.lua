-- EB tested example: Reprice your broker listings
-- econ-broker-reprice | snippet | topics: items
--
-- What it does:  eco.broker:targetPrice says what one listing should cost: the cheapest other seller's price minus
--                cfg.broker.undercut copper (or equal to it with beatAll), never under the friends floor or the item's own price
--                default. eco.broker:reprice() walks every listing of yours and sets each price, accepting it only when the
--                window reads it back.
-- Tested:        1500 from another seller becomes 1495; a market at 1100 stops at the 1200 floor; the listing is repriced.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({
    mine = { { id = 501, name = "Fixture Ore", priceCopper = 2000 } },
    listings = { { name = "Fixture Ore", priceCopper = 1500, seller = "Seller Fixmore" } },
})
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me,
    cfg = { broker = { undercut = 5, friendsFloorCopper = 1000, priceDefaults = { ["fixture ore"] = 1200 } } } })

-- your script: the price rule
local ore = { name = "Fixture Ore" }
DOCS.eq(eco.broker:priceFloor(ore), 1200, "the item's own price default")
DOCS.eq(eco.broker:targetPrice(ore, 2000, 1500), 1495, "undercut by 5")
DOCS.eq(eco.broker:targetPrice(ore, 2000, 1100), 1200, "never under the floor")
DOCS.eq(eco.broker:targetPrice(ore, 2000, nil), 2000, "no other seller: the price stays")

-- reprice every listing of mine
local status
for _ = 1, 20 do
    status = eco.broker:reprice()
    if status ~= "working" then break end
end
for _, line in ipairs(W.log) do print(line) end

-- check
DOCS.eq(status, "done", "repriced")
DOCS.eq(W.broker.mine[1].priceCopper, 1495, "the listing undercuts by 5")
