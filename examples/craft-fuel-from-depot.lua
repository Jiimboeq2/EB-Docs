-- Fetch missing fuel from the fuel depot before a combine
--
-- When the station says the recipe is short of fuel, craftOne pulls the missing fuel from a fuel depot in reach, then crafts. Still short after the pull, it stops and says so.
--
-- kind:      snippet
-- expect:    The coal comes out of the fuel depot into the bags and the lantern is made; with an empty fuel depot the order stops with "out of fuel".
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.craft, eb.economy
-- id:        craft-fuel-from-depot

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
