-- Put bag items up on the broker
--
-- eco.broker:listFromBags() lists what CAN go up, each with a suggested price (its price default, else its merchant value); bound, protected, worthless and not-yet-read items are left out. Nothing goes up until you call eco.broker:addFromInventory(id, copper).
--
-- kind:      snippet
-- expect:    Only the ore is offered (suggested 30 copper); it goes up at 2500.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.broker
-- id:        econ-broker-list-from-bags

-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({ bags = {
    { name = "Fixture Ore", qty = 30, value = 30 },
    { name = "Fixture Heirloom Ring", heirloom = true, value = 900 },
    { name = "Fixture Charm", value = 400 },
    { name = "Fixture Pebble", value = 0 },
    { name = "Fixture Mystery Box", value = 50, type = "Unknown" },
} })
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me,
    cfg = { protect = { names = { ["fixture charm"] = true } } } })

-- your script
local offer = eco.broker:listFromBags()
DOCS.eq(#offer, 1, "one item can go up")
DOCS.eq(offer[1].name, "Fixture Ore", "the ore")
DOCS.eq(offer[1].priceCopper, 30, "suggested at its merchant value")

local status
for _ = 1, 20 do
    status = eco.broker:addFromInventory(offer[1].id, 2500)
    if status ~= "working" then break end
end
print(("listed: %s @ %d"):format(W.broker.mine[1].name, W.broker.mine[1].priceCopper))

-- check
DOCS.eq(status, "done", "listed")
DOCS.eq(W.broker.mine[1].priceCopper, 2500, "at the price given")
