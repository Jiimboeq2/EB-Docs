-- Keep a set amount of coin on you
--
-- eco.bank:coin{ keepCopper = N } opens the bank and deposits what you carry over N, or withdraws the shortfall when you carry less. Coin is counted in copper: 100 copper = 1 silver, 100 silver = 1 gold, 100 gold = 1 platinum. ledgermodel.coin turns copper into the game's words ("4p 0g 0s 0c").
--
-- kind:      snippet
-- expect:    5 platinum carried, 1 kept: 4 platinum go to the bank.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.bank, eb.economy.ledgermodel
-- id:        econ-bank-coin-purse

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
