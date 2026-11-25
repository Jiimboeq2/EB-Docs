-- EB tested example: Keep a set amount of coin on you
-- econ-bank-coin-purse | snippet | topics: items
--
-- What it does:  eco.bank:coin{ keepCopper = N } opens the bank and deposits what you carry over N, or withdraws the shortfall
--                when you carry less. Coin is counted in copper: 100 copper = 1 silver, 100 silver = 1 gold, 100 gold = 1
--                platinum. ledgermodel.coin turns copper into the game's words ("4p 0g 0s 0c").
-- Tested:        5 platinum carried, 1 kept: 4 platinum go to the bank.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({ coin = { bank = 0, carried = 5000000 } })
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me })
local coin = require("eb.economy.ledgermodel").coin

-- your script
local status
for _ = 1, 20 do
    status = eco.bank:coin({ keepCopper = 1000000 })
    if status ~= "working" then break end
end
print(("banked %s, carrying %s"):format(coin(W.bank.coin.bank), coin(W.bank.coin.carried)))

-- check
DOCS.eq(status, "done", "the purse is set")
DOCS.eq(W.bank.coin.carried, 1000000, "1 platinum carried")
DOCS.eq(W.bank.coin.bank, 4000000, "4 platinum banked")
