-- Find an item and hand some to a player
--
-- eco.inventory:search(words, index) finds every bag stack whose name contains the words, plus rows of an index you pass (another box's bags, a depot's contents). eco.inventory:distribute(item, qty, who) trades that many to a player in trade range; a bound item cannot be traded.
--
-- kind:      snippet
-- expect:    Two hits for "ore"; five ore are traded to Friendo; the bound ring is refused.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.inventory
-- id:        econ-search-and-trade

-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({ bags = { { name = "Fixture Ore", qty = 30 }, { name = "Fixture Bound Ring", noTrade = true } },
                       trade = { friendo = true } })
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me })
local inv = eco.inventory

-- your script
local hits = inv:search("ore", { { where = "a harvest depot", name = "Rough Fixture Ore", qty = 200 } })
DOCS.eq(#hits, 2, "the bags and the index")
DOCS.eq(hits[2].where, "a harvest depot", "the index row says where")

local status
for _ = 1, 20 do
    status = inv:distribute("Fixture Ore", 5, "Friendo")
    if status ~= "working" then break end
end
for _, line in ipairs(W.log) do print(line) end
local bound, why
for _ = 1, 20 do
    bound, why = inv:distribute("Fixture Bound Ring", 1, "Friendo")
    if bound ~= "working" then break end
end

-- check
DOCS.eq(status, "done", "traded")
DOCS.eq(W.bags[1].qty, 25, "five ore left the bags")
DOCS.eq(bound, "blocked", "a bound item is never traded")
DOCS.has(why, "bound", "the reason")
