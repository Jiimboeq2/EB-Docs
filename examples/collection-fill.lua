-- Add the collection pieces you already have
--
-- eco.collections:fill(word, { depot = true }) adds every missing piece that is in the bags, then takes the rest from the Collectible Depot in reach and adds those. Adding consumes the piece, so only a piece the journal still misses, not already collected and not protected, is ever added.
--
-- kind:      snippet
-- expect:    The blue shell is added from the bags, the rib comes from the Collectible Depot and is added, the already-collected rib and the unread feather stay in the bags.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.collections, eb.economy
-- id:        collection-fill

-- offline stand-in: the journal, three bag items and the Collectible Depot
local CW = require("crafting.lib.craftworld")
local world = CW.world({
    journal = { { name = "Fixture Shells", category = "Fixture Isle", missing = { "a blue shell" } },
                { name = "Fixture Bones", category = "Fixture Isle", missing = { "a fixture rib" } },
                { name = "Fixture Feathers", category = "Fixture Mainland", missing = { "a gray feather" } } },
    bags = { { id = 1, name = "a blue shell", collectible = true },
             { id = 2, name = "a fixture rib", collectible = true, alreadyCollected = true },
             { id = 3, name = "a gray feather" } },                       -- its details never read: kept
    depots = { collectible = { { name = "a fixture rib", qty = 1, item = { collectible = true } } } } })
local eco = CW.economy(world)

-- your script
local status = CW.poll(function() return eco.collections:fill("all", { depot = true }) end)
local still = eco.collections:missing("all")
print("fill -> " .. status .. "; still missing: " .. table.concat(still, ", "))

-- check
DOCS.eq(status, "done", "the fill finished")
DOCS.eq(#still, 1, "only the feather is still missing")
DOCS.eq(world.depots.collectible[1].qty, 0, "the rib came from the Collectible Depot")
DOCS.eq(#world.bags, 2, "the collected rib and the unread feather stayed")
DOCS.eq(eco.collections:needs("a gray feather (Shiny)"), true, "needs() answers for a shiny you just found")
