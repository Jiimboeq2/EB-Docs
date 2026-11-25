-- Heal whoever fell furthest
--
-- The engine weighs every heal entry by how far its member has fallen; an EMERGENCY heal jumps the queue. One step heals the lowest member with the heaviest choice.
--
-- kind:      snippet
-- expect:    Member2 at 40% is healed with the emergency heal; the plain heal would weigh 80 against its 1080.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.combat, eb.combat.heals, game
-- id:        combat-heal-lowest

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { healthPct = 95 } })
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Mend", "Fixture Rescue" })
for i, m in ipairs({ { "Member1", "templar", 90 }, { "Member2", "wizard", 40 }, { "Member3", "ranger", 75 } }) do
    w.addMember({ name = m[1], id = 10 + i, class = m[2], healthPct = m[3], powerPct = 80, inZone = true })
    w.addActor({ id = 10 + i, name = m[1], type = "PC", isNPC = false, distance = 5 })
end

-- your script
local game = require("eb.platform").game()
local stack = require("eb.caststack.jsonstack").holder({ entries = {
    { name = "Fixture Mend", ability = "Fixture Mend", group = "heal", target = "AllParty", priority = 50,
      gates = { useBelowTargetHP = 80 } },                          -- anyone under 80%
    { name = "Fixture Rescue", ability = "Fixture Rescue", group = "heal", target = "AllParty", priority = 40,
      tags = "EMERGENCY", gates = { useBelowTargetHP = 50 } },      -- anyone under 50%, ahead of every other heal
} })
local engine = require("eb.combat").new({ shim = game.combatShim(), stacks = stack })

engine:loadStack()
local ctx = engine:snapshot()
local plain = engine:healChoice(ctx, stack.get("Fixture Mend"))     -- how much the plain heal wants to cast
local urgent = engine:healChoice(ctx, stack.get("Fixture Rescue"))
local d = engine:step()
print(("heal: %s (%s)"):format(d.ability, d.reason))

-- check
DOCS.eq(plain.target.name, "Member2", "the plain heal would go to the lowest member")
DOCS.eq(plain.weight, 80, "weight 20 + 60 fallen")
DOCS.eq(urgent.weight, 1080, "the emergency heal adds 1000")
DOCS.eq(d.kind, "heal", "a heal decision")
DOCS.eq(d.ability, "Fixture Rescue", "the heaviest choice wins")
DOCS.eq(d.reason, "Member2 at 40%", "on the member who fell furthest")
DOCS.eq(FW.casts(w)[1], "Fixture Rescue", "sent to the game")
