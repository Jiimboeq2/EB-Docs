-- Interrupt the boss's big cast yourself
--
-- When a fight needs one specific stop, read your target's cast bar and fire your stun the moment the cast starts.
--
-- kind:      snippet
-- expect:    Nothing is cast while the boss casts a minor spell; the stun goes out within a tick of Ashen Wail starting.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game, eb.platform
-- id:        fight-interrupt-on-cue

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Stun" })
local boss = FW.mob(w, { id = 300, name = "the Ashen Overseer", type = "NamedNPC" })
FW.target(w, 300)

-- your script
local game = require("eb.platform").game()
local STOP = { ["Ashen Wail"] = true }
require("eb.platform").pulse().every("interrupt watch", 100, function()
    local spell = game.TargetCasting()                     -- "" while nothing is cast
    if STOP[spell] and game.AbilityReady("Fixture Stun") then
        print("stun on " .. spell)
        game.Cast("Fixture Stun")
    end
end)
boss.castId, boss.castName = 41, "Ember Flick"; w.runFor(500)
local early = #w.world.casts
boss.castId, boss.castName = 42, "Ashen Wail"; w.runFor(200)

-- check
DOCS.eq(early, 0, "a minor cast is left alone")
DOCS.eq(#w.world.casts >= 1 and w.world.casts[1].ability, "Fixture Stun", "the big cast is stunned")
