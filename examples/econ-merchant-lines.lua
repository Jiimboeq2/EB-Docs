-- Read a merchant's price and the game's buy lines
--
-- merchantread.parsePriceLabel(label) reads the price under a selected merchant row (a currency amount, or coin); boughtCount(line, item) and refused(line) read the game's own "You buy ..." and refusal lines.
--
-- kind:      snippet
-- expect:    Reads a price of 25 marks, counts a purchase of 3, and recognises a "not enough" refusal.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.merchantread
-- id:        econ-merchant-lines

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
