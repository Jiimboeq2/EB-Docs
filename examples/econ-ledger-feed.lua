-- EB tested example: Record and read the money and item ledger
-- econ-ledger-feed | snippet | topics: items, data
--
-- What it does:  Every sell, deposit, transmute and loot EB does is one ledger line (eco.ledger:add), kept on the PC that wrote
--                it. day(key) sums one day, last12() the last 12 hours, status() is this box's today in one line, and
--                command(words) answers the same words eb ledger takes (status, day <YYYY-MM-DD>, last12, clear <day> | all).
-- Tested:        Two sales (4 items) and a deposit (30 ore) are summed for the day; clearing the day removes its file.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: no files host, so the ledger keeps this session's lines itself
local Fake = require("economy.lib.drivefake")
local W = Fake.world()
local NOW = 1763000000                                         -- a fixed wall-clock time, in seconds
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me, wallNow = function() return NOW end })
local Model = require("eb.economy.ledgermodel")

-- your script
local ledger = eco.ledger
ledger:add({ kind = "sell", item = "Fixture Pelt", qty = 3, cp = 60, where = "Merchant Fixtel" })
ledger:add({ kind = "sell", item = "Fixture Gem", qty = 1, cp = 10000, where = "Merchant Fixtel" })
ledger:note("depot", "Fixture Ore", { qty = 30, where = "a harvest depot" })
DOCS.check(not ledger:add({ kind = "gift", item = "Fixture Pelt" }), "a kind the ledger does not know is not written")

local today = Model.localDay(NOW)
local day = ledger:day(today)
print(Model.countsText(day.sums) .. " (" .. Model.coin(day.sums.cp) .. ")")
DOCS.eq(day.sums.cp, 10060, "the day's coin, in copper")
DOCS.eq(#day.rows, 3, "three lines")
DOCS.has(ledger:status().text, "4 sold", "this box's today (counted in items)")
local ok, text = ledger:command({ "day", today })
DOCS.check(ok and text:find("4 sold", 1, true), "the eb ledger words answer the same")
DOCS.eq(#ledger:last12(NOW).rows, 3, "all three are in the last 12 hours")

-- check: clear the day
local n = ledger:clear(today)
DOCS.eq(n, 1, "one day file removed")
DOCS.eq(#ledger:rows(), 0, "the ledger is empty")
