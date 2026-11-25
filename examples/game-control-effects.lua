-- EB tested example: Find a member who is stunned, feared or rooted
-- game-control-effects | snippet | topics: game, combat, crew, helpers
--
-- What it does:  ControlCount(id) counts the control effects (fear, stun or mez, root) on an actor - you, a group member or a mob
--                - so a cure helper knows whom to cure.
-- Tested:        Finds the stunned member and reads zero for the free one.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addMember({ name = "Tankfixture", id = 11, class = "guardian", healthPct = 80, powerPct = 70, inZone = true,
    isStunned = true })
w.addMember({ name = "Mendfixture", id = 12, class = "templar", healthPct = 90, powerPct = 70, inZone = true })
w.addActor({ id = 11, name = "Tankfixture", type = "PC", isNPC = false, distance = 4, isStunned = true })
w.addActor({ id = 12, name = "Mendfixture", type = "PC", isNPC = false, distance = 6 })

-- your script
local game = require("eb.platform").game()
for _, m in ipairs(game.Group()) do
    local n = game.ControlCount(m.id)
    if n > 0 then print(("cure %s: %d control effect"):format(m.name, n)) end
end

-- check
DOCS.eq(game.ControlCount(11), 1, "the tank is stunned")
DOCS.eq(game.ControlCount(12), 0, "the healer is free")
DOCS.eq(game.ControlCount(0), 0, "an id of 0 is no one")
