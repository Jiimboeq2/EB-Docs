-- EB tested example: Craft one order at the station in reach
-- craft-one-recipe | snippet | topics: items
--
-- What it does:  eco.craft:craftOne(order) selects the recipe, checks fuel, runs each combine with reaction arts and closes the
--                station. It is pollable: call it every tick with the same order until it answers "done".
-- Tested:        Two Fixture Lanterns are made at the work bench, reaction arts were cast during the combines, and the station
--                window is closed at the end.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: a work bench in reach and a recipe book (the game's windows, faked)
local CW = require("crafting.lib.craftworld")
local world = CW.world({ station = { name = "Work Bench" },
    recipes = { { name = "Fixture Lantern", level = 20, device = "Work Bench" } } })
local eco = CW.economy(world)

-- your script: the same call every tick until it is done (EB's tick model: never wait inside a call)
local order = { recipe = "Fixture Lantern", qty = 2 }
local status, why
repeat status, why = eco.craft:craftOne(order, { station = "Work Bench" }) until status ~= "working"
print(("craftOne -> %s (%d made)"):format(status, #world.made))

-- check
DOCS.eq(status, "done", "the order finished")
DOCS.eq(#world.made, 2, "two combines")
DOCS.check(#world.artsUsed > 0, "reaction arts were cast while the combines ran")
DOCS.eq(world.craft.open, false, "the station was closed")
