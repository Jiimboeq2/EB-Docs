-- EB tested example: Turn to face an actor or a point
-- game-face-actor | snippet | topics: game, nav
--
-- What it does:  FaceActor(id) turns you toward an actor; Face(x, z) toward a point on the ground.
-- Tested:        Both turns go out as face commands with the actor's and the point's X and Z.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
