-- Level a new crafter's tradeskill
--
-- eco.skilllevel:levelCrafter{ to, batch } crafts the highest recipe at or under the current tradeskill level, a batch a round, reading the level again before each round, until the target level.
--
-- kind:      snippet
-- expect:    From tradeskill 1 to 3: two nails at level 1, then two hinges at level 2, then done.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.skilllevel, eb.economy
-- id:        skill-level-crafter

-- offline stand-in: a work bench, a recipe book with levels, and a tradeskill level that rises every 2 items
local CW = require("crafting.lib.craftworld")
local world = CW.world({ station = { name = "Work Bench" }, recipes = {
    { name = "Fixture Nail", level = 1, device = "Work Bench" },
    { name = "Fixture Hinge", level = 2, device = "Work Bench" },
    { name = "Fixture Lock", level = 5, device = "Work Bench" } } })
world.ts = 1
world.onMade = function(w) if #w.made % 2 == 0 then w.ts = w.ts + 1 end end
local eco = CW.economy(world, { me = { level = 10 }, shim = { TSLevel = function() return world.ts end } })

-- your script
local status = CW.poll(function() return eco.skilllevel:levelCrafter({ to = 3, batch = 2 }) end)
print(("tradeskill %d reached: %s"):format(world.ts, table.concat(world.made, ", ")))

-- check
DOCS.eq(status, "done", "the target level was reached")
DOCS.eq(world.ts, 3, "tradeskill 3")
DOCS.eq(world.made[3], "Fixture Hinge", "the recipe moved up with the level")
