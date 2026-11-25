-- List doors and clickable things near you
--
-- Clickables(range) lists doors, instance exits and other clickable objects, never people, pets, NPCs or corpses; ClickActor(id) double-clicks one.
--
-- kind:      snippet
-- expect:    Lists the door and the chest-like prop but not the NPC or the corpse, then clicks the nearest one.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-clickables-doors

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
