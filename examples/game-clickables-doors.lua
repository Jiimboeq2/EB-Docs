-- EB tested example: List doors and clickable things near you
-- game-clickables-doors | snippet | topics: game, instances, helpers
--
-- What it does:  Clickables(range) lists doors, instance exits and other clickable objects, never people, pets, NPCs or corpses;
--                ClickActor(id) double-clicks one.
-- Tested:        Lists the door and the chest-like prop but not the NPC or the corpse, then clicks the nearest one.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addActor({ id = 250, name = "a fixture door", type = "Door", isNPC = false, distance = 4 })
w.addActor({ id = 251, name = "an odd fixture urn", type = "Object", isNPC = false, interactable = true, distance = 9 })
w.addActor({ id = 252, name = "a fixture guard", type = "NPC", interactable = true, distance = 3 })
w.addActor({ id = 253, name = "a fixture corpse", type = "Corpse", isNPC = false, distance = 2 })

-- your script
local game = require("eb.platform").game()
local list = game.Clickables(15)                 -- range in metres; an optional max count
local first = list[1]
if first then
    print(("click: %s at %.1f m"):format(first.name, first.distance))
    game.ClickActor(first.id)
end

-- check
DOCS.eq(#list, 2, "the door and the urn, not the NPC or the corpse")
DOCS.eq(first.type, "Door", "nearest clickable first")
DOCS.eq(w.world.actions[#w.world.actions].kind, "click", "a double-click went out")
