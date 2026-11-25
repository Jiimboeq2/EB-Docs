-- EB tested example: Spot the named in the fight
-- game-engaged-named | snippet | topics: game, fights, combat
--
-- What it does:  EngagedNamed(radius, ours) answers a named NPC in combat that is on one of yours (a set of ids) or aggro on you;
--                EngagedMobs(radius, ours) lists every mob on your side's members.
-- Tested:        Finds the named on the tank and lists the two mobs engaged with the group.
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
w.addActor({ id = 280, name = "the Fixture Warden", type = "NamedNPC", inCombatMode = true, targetId = 11,
    distance = 9 })
w.addActor({ id = 281, name = "a fixture add", inCombatMode = true, isAggro = true, targetId = 1, distance = 6 })
w.addActor({ id = 282, name = "a fixture bystander", inCombatMode = true, targetId = 99, distance = 7 })

-- your script: "ours" is a set of the ids on your side (you, the group, their pets)
local game = require("eb.platform").game()
local ours = { [1] = true, [11] = true }
local named = game.EngagedNamed(40, ours)
if named then print(("named up: %s on the tank"):format(named.name)) end
local mobs = game.EngagedMobs(40, ours)

-- check
DOCS.eq(named and named.id, 280, "the named on the tank")
DOCS.eq(#mobs, 2, "the named and the add; the bystander fights someone else")
