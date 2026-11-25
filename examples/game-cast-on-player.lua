-- EB tested example: Cast a heal on a group member by name
-- game-cast-on-player | snippet | topics: game, combat, crew, helpers
--
-- What it does:  Cast(name, { name = who }) uses a beneficial ability on a player without changing your target - the way a healer
--                helper casts on the most hurt member.
-- Tested:        The heal goes out on the hurt member by name and your target stays on the mob.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
