-- Craft a list of orders
--
-- eco.craft:queue(orders) crafts each order in turn and answers "done" when the last one is finished, or "blocked" with the order it stalled on.
--
-- kind:      snippet
-- expect:    Two orders (three items) are crafted in order; a queue naming a recipe the book lacks stops on it.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.craft, eb.economy
-- id:        craft-queue

-- offline stand-in: a work bench and a two-recipe book
local CW = require("crafting.lib.craftworld")
local world = CW.world({ station = { name = "Work Bench" }, recipes = {
    { name = "Fixture Lantern", level = 20, device = "Work Bench" },
    { name = "Fixture Spoon", level = 10, device = "Work Bench" } } })
local eco = CW.economy(world)

-- your script
local orders = { { recipe = "Fixture Lantern", qty = 2 }, { recipe = "Fixture Spoon", qty = 1 } }
local status = CW.poll(function() return eco.craft:queue(orders) end)
print("queue -> " .. status .. ": " .. table.concat(world.made, ", "))

local stuck, why = CW.poll(function() return eco.craft:queue({ { recipe = "Fixture Anvil", qty = 1 } }) end)
print("queue -> " .. stuck .. ": " .. tostring(why))

-- check
DOCS.eq(status, "done", "the queue finished")
DOCS.eq(#world.made, 3, "three items")
DOCS.eq(world.made[3], "Fixture Spoon", "in order")
DOCS.eq(stuck, "blocked", "an unknown recipe stops the queue")
DOCS.has(why, "Fixture Anvil", "and says which order")
