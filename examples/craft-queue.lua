-- EB tested example: Craft a list of orders
-- craft-queue | snippet | topics: items
--
-- What it does:  eco.craft:queue(orders) crafts each order in turn and answers "done" when the last one is finished, or "blocked"
--                with the order it stalled on.
-- Tested:        Two orders (three items) are crafted in order; a queue naming a recipe the book lacks stops on it.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
