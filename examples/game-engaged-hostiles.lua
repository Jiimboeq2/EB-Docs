-- EB tested example: Count the mobs fighting you
-- game-engaged-hostiles | snippet | topics: game, combat, fights
--
-- What it does:  CountEngagedHostiles(radius) answers how many living NPCs in combat are aggro on you, and how many are in combat
--                at all, from one sweep a frame shared by every combat read.
-- Tested:        Counts two aggro mobs and three in combat inside 30 m; the idle one and the far one are not counted.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
