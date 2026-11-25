-- Equip an item from your bags
--
-- HasItemExact(name) looks in the bags only (never at worn gear); EquipFromBags(name) equips it. Both take the item's exact name.
--
-- kind:      snippet
-- expect:    The shawl in the bags is equipped; a worn item is not seen by HasItemExact.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-equip-from-bags

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.world.items = {
    ["Fixture Shawl"] = { where = "bag", id = 41, usable = false },
    ["Fixture Blade"] = { where = "worn", slot = "primary", id = 42, usable = true },
}

-- your script
local game = require("eb.platform").game()
if game.HasItemExact("Fixture Shawl") and game.EquipFromBags("Fixture Shawl") then
    print("equipped Fixture Shawl")
end

-- check
DOCS.eq(w.world.items["Fixture Shawl"].where, "worn", "the shawl is on")
DOCS.eq(game.HasItemExact("Fixture Blade"), false, "bags only: worn gear is not seen")
DOCS.eq(game.HasItem("Fixture Blade"), true, "HasItem sees worn gear too")
