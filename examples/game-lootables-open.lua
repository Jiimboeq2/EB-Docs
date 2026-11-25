-- Find corpses and chests to loot
--
-- Lootables(reach) lists corpses and chests in reach, nearest first; OpenLoot(id) opens one.
--
-- kind:      snippet
-- expect:    Finds the corpse and the chest inside 6 m (not the far one) and opens the nearest.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-lootables-open

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
