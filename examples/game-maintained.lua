-- EB tested example: List the spells you keep up
-- game-maintained | snippet | topics: game, combat, helpers
--
-- What it does:  Maintained() lists your maintained spells with their target and time left; a duration of -1 means the spell has
--                no timer (a stance or a toggle).
-- Tested:        Finds the buff that is about to drop and tells the timer-less stance apart.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addActor({ id = 11, name = "Tankfixture", type = "PC", isNPC = false, distance = 4 })
w.addMaintained({ name = "Fixture Haste", targetId = 11, targetType = "Single", duration = 4 })
w.addMaintained({ name = "Fixture Stance", targetId = 1, targetType = "Self", duration = -1 })
w.addMaintained({ name = "Fixture Shield", targetId = 11, targetType = "Single", duration = 90 })

-- your script
local game = require("eb.platform").game()
local soon, toggles = {}, 0
for _, s in ipairs(game.Maintained()) do
    if s.duration == -1 then toggles = toggles + 1
    elseif s.duration < 10 then soon[#soon + 1] = s end
end
for _, s in ipairs(soon) do
    local who = game.ActorPos(s.targetId)
    print(("refresh soon: %s on %s (%d s left)"):format(s.name, who and who.name or "?", s.duration))
end

-- check
DOCS.eq(#game.Maintained(), 3, "three maintained spells")
DOCS.eq(#soon, 1, "one is about to drop")
DOCS.eq(toggles, 1, "the stance has no timer")
