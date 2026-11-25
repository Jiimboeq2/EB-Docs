-- Cast an ability when it is ready
--
-- AbilityReady(name) says whether an ability can be used now; Cast(name) uses it on your current target. The game records what it was told to cast.
--
-- kind:      snippet
-- expect:    Casts the ready ability on the target and skips the one still on its timer.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-ready-and-cast

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addAbility({ id = 5001, name = "Fixture Strike", ready = true })
w.addAbility({ id = 5003, name = "Fixture Mend", ready = false, secondsUntilReady = 4 })
w.addActor({ id = 220, name = "a fixture boar", distance = 5 })
w.self.targetId = 220

-- your script
local game = require("eb.platform").game()
local cast = {}
for _, name in ipairs({ "Fixture Strike", "Fixture Mend" }) do
    if game.AbilityReady(name) then
        game.Cast(name)                                 -- no target given: used on your current target
        cast[#cast + 1] = name
    end
end
print(("cast %s on %s; Fixture Mend ready in %d s"):format(cast[1], game.Target().name,
    game.AbilityTimeUntilReady("Fixture Mend")))

-- check: the fake world recorded every ability the game was told to use
DOCS.eq(#w.world.casts, 1, "one cast went out")
DOCS.eq(w.world.casts[1].ability, "Fixture Strike", "the ready one")
DOCS.eq(w.world.casts[1].target, 220, "on the current target")
