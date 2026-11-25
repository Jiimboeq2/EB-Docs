-- EB tested example: Search actors with a query
-- tlo-actor-query | snippet | topics: tlos, game, helpers
--
-- What it does:  ActorsNear(query, radius) runs one game actor query; its terms are actor members (Type, Level, Health,
--                InCombatMode ...), and EB refuses a query that names a member it has not verified.
-- Tested:        Lists the two high-level NPCs; a query naming a member that is not verified yet answers an empty list.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addActor({ id = 320, name = "a fixture elder", level = 99, distance = 12 })
w.addActor({ id = 321, name = "a fixture whelp", level = 20, distance = 8 })
w.addActor({ id = 322, name = "a fixture elder", level = 97, distance = 25 })

-- your script: query terms are combined with && || ! and compared with == != < > <= >=
local game = require("eb.platform").game()
local big = game.ActorsNear('Type == "NPC" && Level >= 95 && Health > 0', 30)
print(("%d NPCs of level 95+ within 30 m"):format(#big))
local refused = game.ActorsNear('Type == "NPC" && IsNamed', 30)   -- IsNamed is not verified yet: refused

-- check
DOCS.eq(#big, 2, "the two elders")
DOCS.eq(big[1].id, 320, "nearest first")
DOCS.eq(#refused, 0, "a query with a member that is not verified yet sends nothing")
