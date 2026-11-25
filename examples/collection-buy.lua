-- EB tested example: Buy the missing collection pieces - the three models
-- collection-buy | snippet | topics: items
--
-- What it does:  eco.collections:buy(word, opts) plans by default ("confirm": counts and stops), hands back the buy list
--                ("queue"), or buys on the broker ("auto") - and auto refuses without a per-piece price cap. A piece already in
--                the bags is never bought.
-- Tested:        confirm and queue spend nothing, auto without a cap is refused, auto with a 100 copper cap buys the shell (the
--                purchase question answered for it) and passes the rib that costs more.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: two missing pieces, both on the broker, one too dear
local CW = require("crafting.lib.craftworld")
local world = CW.world({
    journal = { { name = "Fixture Shells", category = "Fixture Isle", missing = { "a blue shell", "a fixture rib" } } },
    listings = { { id = 1, name = "a blue shell", priceCopper = 40 }, { id = 2, name = "a fixture rib", priceCopper = 400 } } })
local eco = CW.economy(world)

-- your script
local _, confirm = eco.collections:buy("shells")                                   -- the default model
local _, queued = eco.collections:buy("shells", { model = "queue" })
local refused, why = eco.collections:buy("shells", { model = "auto" })
local status = CW.poll(function() return eco.collections:buy("shells", { model = "auto", maxCopper = 100 }) end)
local bought = {}
for _, it in ipairs(world.bags) do bought[#bought + 1] = it.name end
print(("auto -> %s: bought %s; the rib was over the cap"):format(status, table.concat(bought, ", ")))

-- check
DOCS.eq(confirm.model .. " " .. #confirm.plan, "confirm 2", "confirm plans two and stops")
DOCS.eq(#queued.plan, 2, "queue hands back the list")
DOCS.eq(refused, "blocked", "auto with no cap is refused")
DOCS.has(why, "price cap", "and says why")
DOCS.eq(#bought, 1, "only the piece under the cap")
DOCS.eq(world.answers[1].choice, 1, "its purchase question was answered Yes")
