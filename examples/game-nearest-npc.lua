-- Find the nearest NPC by name
--
-- NearestActor(query, radius, nameHas) runs one game query and answers the nearest match; ActorsNear() answers them all, nearest first.
--
-- kind:      snippet
-- expect:    Finds the closer of two fixture rats inside 30 m and lists every NPC in range, nearest first.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-nearest-npc

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addActor({ id = 240, name = "a fixture rat", distance = 18 })
w.addActor({ id = 241, name = "a fixture rat", distance = 7 })
w.addActor({ id = 242, name = "a fixture bat", distance = 11 })
w.addActor({ id = 243, name = "a fixture rat", distance = 55 })        -- out of range

-- your script
local game = require("eb.platform").game()
local rat = game.NearestActor('Type == "NPC"', 30, "rat")              -- query, radius (m), name contains
if rat then print(("nearest rat: %s (id %d) at %.1f m"):format(rat.name, rat.id, rat.distance)) end
local all = game.ActorsNear('Type == "NPC"', 30)

-- check
DOCS.eq(rat.id, 241, "the nearer rat")
DOCS.eq(#all, 3, "three NPCs inside 30 m")
DOCS.eq(all[1].id, 241, "nearest first")
