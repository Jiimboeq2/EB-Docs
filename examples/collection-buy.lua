-- Buy the missing collection pieces - the three models
--
-- eco.collections:buy(word, opts) plans by default ("confirm": counts and stops), hands back the buy list ("queue"), or buys on the broker ("auto") - and auto refuses without a per-piece price cap. A piece already in the bags is never bought.
--
-- kind:      snippet
-- expect:    confirm and queue spend nothing, auto without a cap is refused, auto with a 100 copper cap buys the shell (the purchase question answered for it) and passes the rib that costs more.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.collections, eb.economy
-- id:        collection-buy

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
