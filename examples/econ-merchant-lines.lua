-- EB tested example: Read a merchant's price and the game's buy lines
-- econ-merchant-lines | snippet | topics: items, events
--
-- What it does:  merchantread.parsePriceLabel(label) reads the price under a selected merchant row (a currency amount, or coin);
--                boughtCount(line, item) and refused(line) read the game's own "You buy ..." and refusal lines.
-- Tested:        Reads a price of 25 marks, counts a purchase of 3, and recognises a "not enough" refusal.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local MR = require("eb.economy.merchantread")
local link = string.char(92) .. "aITEM 123 456:[Fixture Mark]" .. string.char(92) .. "/a"      -- the game's item link
local price = MR.parsePriceLabel("Fixture Stone\n25 " .. link)
local n = MR.boughtCount("You buy 3 Fixture Stone from a fixture merchant.", "Fixture Stone")
local why = MR.refused("You need 25 Fixture Mark to purchase Fixture Stone.")
print(("price: %d %s; bought %d; refused: %s"):format(price.amount, price.currency, n, why))

-- check
DOCS.eq(price.amount, 25, "the amount")
DOCS.eq(price.coin, false, "a currency price, not coin")
DOCS.eq(MR.parsePriceLabel("Fixture Stone"), nil, "a name alone has no price")
DOCS.eq(MR.refused("You buy 1 Fixture Stone."), "none", "not a refusal")
