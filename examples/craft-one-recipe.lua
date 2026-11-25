-- Craft one order at the station in reach
--
-- eco.craft:craftOne(order) selects the recipe, checks fuel, runs each combine with reaction arts and closes the station. It is pollable: call it every tick with the same order until it answers "done".
--
-- kind:      snippet
-- expect:    Two Fixture Lanterns are made at the work bench, reaction arts were cast during the combines, and the station window is closed at the end.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.craft, eb.economy
-- id:        craft-one-recipe

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
