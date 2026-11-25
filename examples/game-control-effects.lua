-- Find a member who is stunned, feared or rooted
--
-- ControlCount(id) counts the control effects (fear, stun or mez, root) on an actor - you, a group member or a mob - so a cure helper knows whom to cure.
--
-- kind:      snippet
-- expect:    Finds the stunned member and reads zero for the free one.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-control-effects

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
