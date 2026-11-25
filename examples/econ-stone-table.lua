-- EB tested example: Read a stone merchant's rows
-- econ-stone-table | snippet | topics: items
--
-- What it does:  merchantread turns the rows of a merchant that sells transmuter's stones for a currency into a table: the
--                currency the stones cost, the stones cheapest first, and the exchange rows that turn another currency into it.
--                pickStone chooses one, usableExchanges says which exchanges you can pay for, and stopReason says why a run
--                should stop. All pure: they read what the window driver handed back, never the game.
-- Tested:        The stones cost Fixture Crests; the 25-crest exchange is usable with crowns; a maxed skill stops the run.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- the merchant's rows, as a window driver reads them
local rows = {
    { index = 1, name = "Greater Transmuter's Stone", price = { amount = 12, currency = "Fixture Crest" } },
    { index = 2, name = "Lesser Transmuter's Stone", price = { amount = 5, currency = "Fixture Crest" } },
    { index = 3, name = "Fixture Crest (25)", price = { amount = 1, currency = "Fixture Crown" } },
}

-- your script
local MR = require("eb.economy.merchantread")
local t = MR.buildStoneTable(rows)
local list = {}
for _, s in ipairs(t.stones) do list[#list + 1] = s.name .. " " .. s.price end
print("stones in " .. t.currency .. ": " .. table.concat(list, ", "))

DOCS.eq(MR.exchangeGives("Fixture Crest (25)", "Fixture Crest"), 25, "an exchange row gives 25")
DOCS.eq(MR.pickStone(t, "greater"), 2, "asked by part of its name")
DOCS.eq(MR.pickStone(t, "", 1), 2, "the cheapest, one price step up")
local usable = MR.usableExchanges(t, { ["Fixture Crown"] = 3 })
DOCS.eq(#usable, 1, "the crowns pay for the exchange")

-- check
DOCS.eq(t.currency, "Fixture Crest", "the stones' currency")
DOCS.eq(t.stones[1].price, 5, "cheapest first")
DOCS.has(MR.stopReason(100, 100, 20, 4, true, 0, 5), "at its max", "a maxed skill stops")
DOCS.has(MR.stopReason(10, 100, 3, 4, true, 0, 5), "bag slots", "full bags stop")
DOCS.eq(MR.stopReason(10, 100, 20, 4, true, 0, 5), "", "otherwise go on")
