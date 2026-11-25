-- EB tested example: Read your own character
-- game-me-basics | snippet | topics: helpers, game
--
-- What it does:  Get the game layer from eb.platform and read Me(): name, level, class, health, power and zone in one call.
-- Tested:        Prints one status line for your character and checks the health and zone it read.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
