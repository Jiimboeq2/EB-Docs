-- EB tested example: Buy from a merchant and answer the purchase question
-- econ-merchant-buy-confirm | snippet | topics: items, helpers, dialogs
--
-- What it does:  eco.vendor:buyFromMerchant(name, qty) buys the row by its exact name and answers the game's "Are you sure you
--                want to purchase X?" with Yes ONLY when X is the item you are buying - a question naming anything else is
--                answered No and the buy stops. A name that several rows share at different prices is refused before any click.
-- Tested:        The lantern kit is bought on a Yes; a question naming another item is answered No; a shared-name row is refused.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({ offers = {
    { name = "Fixture Lantern Kit", asks = true },                        -- a currency row: the game asks first
    { name = "Fixture Exchange", price = { amount = 1, currency = "Fixture Crest" } },
    { name = "Fixture Exchange", price = { amount = 5, currency = "Fixture Crown" } },
} })
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me })

local function buy(name, qty)
    local s, why
    for _ = 1, 20 do
        s, why = eco.vendor:buyFromMerchant(name, qty)
        if s ~= "working" then return s, why end
    end
    return s, why
end

-- your script, part 1: the question names our item -> Yes
local s1 = buy("Fixture Lantern Kit", 1)
for _, line in ipairs(W.log) do if line:find("^yes") then print(line) end end
DOCS.eq(s1, "done", "bought")

-- part 2: the question names something else -> No, and the buy stops
W.askOther = "Fixture Gold Crown"
local s2, why2 = buy("Fixture Lantern Kit", 1)
W.askOther = nil
DOCS.eq(s2, "blocked", "a question about another item is never answered Yes")
DOCS.has(why2, "different item", "and the reason says so")

-- part 3: two rows share a name at different prices -> refused before any click
local s3, why3 = buy("Fixture Exchange", 1)

-- check
DOCS.eq(s3, "blocked", "a shared-name row is not bought by name")
DOCS.has(why3, "several rows", "the reason")
DOCS.has(W.log[#W.log] or "", "no:", "the last answer to the game was No")
