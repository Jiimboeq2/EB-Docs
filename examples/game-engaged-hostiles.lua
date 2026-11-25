-- Count the mobs fighting you
--
-- CountEngagedHostiles(radius) answers how many living NPCs in combat are aggro on you, and how many are in combat at all, from one sweep a frame shared by every combat read.
--
-- kind:      snippet
-- expect:    Counts two aggro mobs and three in combat inside 30 m; the idle one and the far one are not counted.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-engaged-hostiles

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.self.inCombat = true
w.addActor({ id = 270, name = "a fixture brute", inCombatMode = true, isAggro = true, distance = 5 })
w.addActor({ id = 271, name = "a fixture brute", inCombatMode = true, isAggro = true, distance = 8 })
w.addActor({ id = 272, name = "a fixture caller", inCombatMode = true, isAggro = false, distance = 12 })
w.addActor({ id = 273, name = "a fixture sleeper", inCombatMode = false, distance = 6 })
w.addActor({ id = 274, name = "a fixture brute", inCombatMode = true, isAggro = true, distance = 60 })

-- your script
local game = require("eb.platform").game()
local aggro, inCombat = game.CountEngagedHostiles(30)
print(("aggro %d, in combat %d"):format(aggro, inCombat))
if aggro >= 2 and game.Me().inCombat then print("more than one on me: an area spell is worth it") end

-- check
DOCS.eq(aggro, 2, "aggro on me")
DOCS.eq(inCombat, 3, "in combat within 30 m")
