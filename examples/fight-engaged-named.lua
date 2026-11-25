-- Who is in the fight
--
-- One combat sweep a frame answers how many hostiles are on you, whether a named is engaged, and the engaged mobs themselves.
--
-- kind:      snippet
-- expect:    Three mobs are in combat (two on you); the engaged named is the Overseer; the list carries all three.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        fight-engaged-named

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
FW.mob(w, { id = 300, name = "the Ashen Overseer", type = "NamedNPC", distance = 10 })
FW.mob(w, { id = 301, name = "an ashen add", distance = 6 })
FW.mob(w, { id = 302, name = "an ashen add", distance = 14, isAggro = false, targetId = 11 })
w.addActor({ id = 11, name = "Member1", type = "PC", isNPC = false, distance = 3 })   -- the member it is on

-- your script
local game = require("eb.platform").game()
local onMe, inFight = game.CountEngagedHostiles(30)         -- aggro on you, and everything in combat in reach
local named = game.EngagedNamed(40, { [11] = true })        -- a named in combat on you or on one of `ours`
local mobs = game.EngagedMobs(40, { [11] = true })
print(("%d on me, %d in the fight"):format(onMe, inFight))
print("engaged named: " .. (named and named.name or "none"))

-- check
DOCS.eq(onMe, 2, "two on you")
DOCS.eq(inFight, 3, "three in the fight")
DOCS.eq(named and named.id, 300, "the named")
DOCS.eq(#mobs, 3, "every engaged mob, on you or on a member")
