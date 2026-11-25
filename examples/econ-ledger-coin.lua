-- Coin in words and a day's sums
--
-- ledgermodel.coin(copper) writes coin the way the game says it ("1p 23g 4s 5c", leading zero units left out); newSums / addRow / countsText add up a day of ledger rows (sells, deposits, loot).
--
-- kind:      snippet
-- expect:    Two sells and a loot line add up to the right copper and the right counts.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.ledgermodel
-- id:        econ-ledger-coin

-- your script
local L = require("eb.economy.ledgermodel")
local sums = L.newSums()
for _, row in ipairs({
    { kind = L.kindOf("sell"), qty = 1, cp = 75000, item = "a fixture blade" },
    { kind = L.kindOf("sell"), qty = 1, cp = 50000, item = "a fixture vest" },
    { kind = L.kindOf("loot"), qty = 1, cp = 0, item = "a fixture pelt" },
}) do L.addRow(sums, row) end
print(("earned %s; %s"):format(L.coin(sums.cp), L.countsText(sums)))

-- check
DOCS.eq(L.coin(12345), "1g 23s 45c", "leading zero units are left out")
DOCS.eq(L.coin(0), "0c", "none at all")
DOCS.eq(sums.cp, 125000, "the copper of both sells")
