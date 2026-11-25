-- Cast a heal on a group member by name
--
-- Cast(name, { name = who }) uses a beneficial ability on a player without changing your target - the way a healer helper casts on the most hurt member.
--
-- kind:      snippet
-- expect:    The heal goes out on the hurt member by name and your target stays on the mob.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-cast-on-player

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addAbility({ id = 5004, name = "Fixture Mend", ready = true })
w.addMember({ name = "Mendfixture", id = 12, class = "templar", healthPct = 35, powerPct = 80, inZone = true })
w.addActor({ id = 12, name = "Mendfixture", type = "PC", isNPC = false, distance = 8 })
w.addActor({ id = 220, name = "a fixture boar", distance = 5 })
w.self.targetId = 220

-- your script
local game = require("eb.platform").game()
for _, m in ipairs(game.Group()) do
    if m.inZone and not m.isDead and m.healthPct < 50 and game.AbilityReady("Fixture Mend") then
        game.Cast("Fixture Mend", { name = m.name })
        print(("healed %s (%d%%)"):format(m.name, m.healthPct))
    end
end

-- check
DOCS.eq(w.world.casts[1].target, "Mendfixture", "cast on the member by name")
DOCS.eq(w.world.casts[1].onPlayer, true, "without touching your target")
DOCS.eq(w.self.targetId, 220, "your target is still the boar")
