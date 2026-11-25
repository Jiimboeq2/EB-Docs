-- See which mobs are casting
--
-- MobCasts(radius) lists the engaged mobs that are casting right now, with the cast id, its time and whether your line of sight to them is clear - what an interrupt needs.
--
-- kind:      snippet
-- expect:    Lists the one casting mob with its cast id and a clear line of sight.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-mob-casts

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
