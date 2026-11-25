-- Turn to face an actor or a point
--
-- FaceActor(id) turns you toward an actor; Face(x, z) toward a point on the ground.
--
-- kind:      snippet
-- expect:    Both turns go out as face commands with the actor's and the point's X and Z.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-face-actor

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addActor({ id = 230, name = "a fixture lever", type = "NoKill NPC", x = 40, y = 2, z = -15, distance = 6 })

-- your script
local game = require("eb.platform").game()
game.FaceActor(230)                 -- turns toward the lever's own X / Z
game.Face(12.5, 30)                 -- turns toward a spot: x, z (the height does not matter)

-- check: the fake world recorded each turn the game was told to make
local faces = {}
for _, a in ipairs(w.world.actions) do if a.kind == "face" then faces[#faces + 1] = a end end
DOCS.eq(#faces, 2, "two turns")
DOCS.eq(faces[1].x, 40, "toward the lever's X")
DOCS.eq(faces[1].z, -15, "...and Z")
DOCS.eq(faces[2].x, 12.5, "toward the spot")
