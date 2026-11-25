-- Read your own character
--
-- Get the game layer from eb.platform and read Me(): name, level, class, health, power and zone in one call.
--
-- kind:      snippet
-- expect:    Prints one status line for your character and checks the health and zone it read.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game, eb.platform
-- id:        game-me-basics

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { healthPct = 64, powerPct = 80, zone = "a test hall" } })

-- your script
local game = require("eb.platform").game()
local me = game.Me()                     -- ONE batched read per tick answers every field below
print(("%s lvl %d %s  hp %d%%  power %d%%  in %s"):format(
    me.name, me.level, me.subclass, me.healthPct, me.powerPct or -1, me.zone))

-- check
DOCS.eq(me.healthPct, 64, "health in percent")
DOCS.eq(me.zone, "a test hall", "the zone's display name")
DOCS.check(game.InGame(), "in the world")
