-- EB tested example: Equip an item from your bags
-- game-equip-from-bags | snippet | topics: game, items
--
-- What it does:  HasItemExact(name) looks in the bags only (never at worn gear); EquipFromBags(name) equips it. Both take the
--                item's exact name.
-- Tested:        The shawl in the bags is equipped; a worn item is not seen by HasItemExact.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
