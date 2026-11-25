-- EB tested example: Fetch missing fuel from the fuel depot before a combine
-- craft-fuel-from-depot | snippet | topics: items
--
-- What it does:  When the station says the recipe is short of fuel, craftOne pulls the missing fuel from a fuel depot in reach,
--                then crafts. Still short after the pull, it stops and says so.
-- Tested:        The coal comes out of the fuel depot into the bags and the lantern is made; with an empty fuel depot the order
--                stops with "out of fuel".
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: the recipe needs 3 coal the bags do not have; the fuel depot in reach has 20
local CW = require("crafting.lib.craftworld")
local world = CW.world({ station = { name = "Work Bench" }, fuelOk = false,
    fuelNeed = { { name = "Fixture Coal", qty = 3 } },
    depots = { fuel = { { name = "Fixture Coal", qty = 20 } } },
    recipes = { { name = "Fixture Lantern", level = 20, device = "Work Bench" } } })
local eco = CW.economy(world)

-- your script
local status = CW.poll(function() return eco.craft:craftOne("Fixture Lantern") end)
local coal = 0
for _, it in ipairs(world.bags) do if it.name == "Fixture Coal" then coal = it.qty end end
print(("fuel pulled: %d Fixture Coal, craft %s"):format(coal, status))

-- the same order with the fuel depot empty
local dry = CW.world({ station = { name = "Work Bench" }, fuelOk = false,
    fuelNeed = { { name = "Fixture Coal", qty = 3 } }, depots = { fuel = {} },
    recipes = { { name = "Fixture Lantern", level = 20, device = "Work Bench" } } })
local ecoDry = CW.economy(dry)
local stuck, why = CW.poll(function() return ecoDry.craft:craftOne("Fixture Lantern") end)
print(stuck .. ": " .. tostring(why))

-- check
DOCS.eq(coal, 3, "the missing fuel came from the depot")
DOCS.eq(world.depots.fuel[1].qty, 17, "and left the depot")
DOCS.eq(status, "done", "then the lantern was made")
DOCS.eq(stuck, "blocked", "no fuel anywhere stops the order")
