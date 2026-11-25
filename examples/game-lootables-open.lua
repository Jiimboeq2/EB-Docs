-- EB tested example: Find corpses and chests to loot
-- game-lootables-open | snippet | topics: game, items, loot
--
-- What it does:  Lootables(reach) lists corpses and chests in reach, nearest first; OpenLoot(id) opens one.
-- Tested:        Finds the corpse and the chest inside 6 m (not the far one) and opens the nearest.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addActor({ id = 260, name = "a fixture corpse", type = "Corpse", isNPC = false, distance = 2 })
w.addActor({ id = 261, name = "a small fixture chest", type = "Chest", isNPC = false, distance = 5 })
w.addActor({ id = 262, name = "a far fixture corpse", type = "Corpse", isNPC = false, distance = 20 })

-- your script
local game = require("eb.platform").game()
local loot = game.Lootables(6)                   -- reach in metres (default 6)
if #loot > 0 then
    print(("%d to loot, opening %s"):format(#loot, loot[1].name))
    game.OpenLoot(loot[1].id)
end

-- check
DOCS.eq(#loot, 2, "two inside 6 m")
DOCS.eq(loot[1].type, "Corpse", "the nearest is the corpse")
DOCS.eq(loot[2].type, "Chest", "chests are listed too")
DOCS.eq(w.world.actions[#w.world.actions].id, 260, "the corpse was opened")
