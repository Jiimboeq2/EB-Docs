-- Buy what you are short of, under a price cap
--
-- eco.broker:buy(name, { count, maxCopper, optional }) counts what the bags already hold, buys only the shortfall from the cheapest listing under the cap, and answers the purchase question for that exact item. With optional = true a missing item is skipped instead of stopping the run.
--
-- kind:      snippet
-- expect:    One oil is held, three wanted: two are bought from the 400-copper listing (the 900 one is over the cap).
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.broker, eb.economy.confirm
-- id:        econ-broker-buy-capped

-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({
    bags = { { name = "Fixture Lantern Oil", qty = 1 } },
    listings = { { name = "Fixture Lantern Oil", priceCopper = 900, seller = "Seller A", asks = true },
                 { name = "Fixture Lantern Oil", priceCopper = 400, seller = "Seller B", asks = true } },
})
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me })

-- your script
local function buy(name, opts)
    local s, why
    for _ = 1, 20 do
        s, why = eco.broker:buy(name, opts)
        if s ~= "working" then return s, why end
    end
    return s, why
end
local status = buy("Fixture Lantern Oil", { count = 3, maxCopper = 500 })
for _, line in ipairs(W.log) do if line:find("^yes") then print(line) end end

-- an item nobody sells under the cap: optional moves on, otherwise the run stops
local skip = buy("Fixture Rare Gem", { count = 1, maxCopper = 10, optional = true })
local stop, why = buy("Fixture Rare Gem", { count = 1, maxCopper = 10 })

-- check
DOCS.eq(status, "done", "bought")
DOCS.eq(W.bags[1].qty, 3, "three in the bags now")
DOCS.eq(skip, "done", "optional: skipped")
DOCS.eq(stop, "blocked", "not optional: the run stops")
DOCS.has(why, "under cap", "and says why")
