-- EB tested example: Coin in words and a day's sums
-- econ-ledger-coin | snippet | topics: items, data, ui
--
-- What it does:  ledgermodel.coin(copper) writes coin the way the game says it ("1p 23g 4s 5c", leading zero units left out);
--                newSums / addRow / countsText add up a day of ledger rows (sells, deposits, loot).
-- Tested:        Two sells and a loot line add up to the right copper and the right counts.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
