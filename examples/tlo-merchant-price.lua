-- What a merchant pays for a bag item
--
-- With a merchant window open, MerchantWindow.MyInventory["name"].PriceString is what it pays for one of your items, and .Quantity how many you hold.
--
-- kind:      snippet
-- expect:    Reads the offer for the ore while the window is open; with the window closed it reads FALSE for IsVisible.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        tlo-merchant-price

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.world.items = { ["Fixture Ore"] = { where = "bag", quantity = 5, id = 71, priceString = "0p,1g,20s,0c" } }
w.setWindow("merchant", { forSale = 3 })

-- your script
local raw = IS.Parse('${MerchantWindow.IsVisible}|${MerchantWindow.MyInventory["Fixture Ore"].Quantity}|' ..
    '${MerchantWindow.MyInventory["Fixture Ore"].PriceString}')
local visible, qty, price = raw:match("^([^|]*)|([^|]*)|([^|]*)$")
if visible == "TRUE" then print(("Fixture Ore x%s: %s each"):format(qty, price)) end
w.setWindow("merchant", nil)                       -- the window closes

-- check
DOCS.eq(visible, "TRUE", "the window is open")
DOCS.eq(tonumber(qty), 5, "how many you hold")
DOCS.eq(IS.Parse("${MerchantWindow.IsVisible}"), "FALSE", "closed")
