-- EB tested example: Add the collection pieces you already have
-- collection-fill | snippet | topics: items, helpers
--
-- What it does:  eco.collections:fill(word, { depot = true }) adds every missing piece that is in the bags, then takes the rest
--                from the Collectible Depot in reach and adds those. Adding consumes the piece, so only a piece the journal still
--                misses, not already collected and not protected, is ever added.
-- Tested:        The blue shell is added from the bags, the rib comes from the Collectible Depot and is added, the
--                already-collected rib and the unread feather stay in the bags.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
