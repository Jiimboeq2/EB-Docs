-- EB tested example: See which mobs are casting
-- game-mob-casts | snippet | topics: game, combat, fights
--
-- What it does:  MobCasts(radius) lists the engaged mobs that are casting right now, with the cast id, its time and whether your
--                line of sight to them is clear - what an interrupt needs.
-- Tested:        Lists the one casting mob with its cast id and a clear line of sight.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addActor({ id = 290, name = "a fixture shaman", inCombatMode = true, isAggro = true, distance = 14,
    castId = 4242, castSecs = 2.5 })
w.addActor({ id = 291, name = "a fixture brute", inCombatMode = true, isAggro = true, distance = 5 })

-- your script
local game = require("eb.platform").game()
for _, c in ipairs(game.MobCasts(35)) do
    print(("%s casts %d (%.1f s), line %s"):format(c.mobName, c.castId, c.baseSec, c.los and "clear" or "blocked"))
end
local casts = game.MobCasts(35)

-- check
DOCS.eq(#casts, 1, "only the caster is listed")
DOCS.eq(casts[1].mobId, 290, "the shaman")
DOCS.eq(casts[1].los, true, "nothing blocks the line")
