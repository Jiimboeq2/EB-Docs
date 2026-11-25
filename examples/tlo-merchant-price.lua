-- EB tested example: What a merchant pays for a bag item
-- tlo-merchant-price | snippet | topics: tlos, items
--
-- What it does:  With a merchant window open, MerchantWindow.MyInventory["name"].PriceString is what it pays for one of your
--                items, and .Quantity how many you hold.
-- Tested:        Reads the offer for the ore while the window is open; with the window closed it reads FALSE for IsVisible.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
