-- EB tested example: Where an actor stands, and whether it is gone
-- game-actor-pos | snippet | topics: game, nav, combat
--
-- What it does:  ActorPos(id) answers an actor's position, heading and distance; ActorDead(id) is true when it is dead or no
--                longer in the zone; ActorHeading(id) is its facing in degrees, or nil when it is gone.
-- Tested:        Reads the mob's position, then calls it dead once it has despawned.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addActor({ id = 220, name = "a fixture boar", x = 12, y = 0, z = -8.5, heading = 90, distance = 14 })

-- your script
local game = require("eb.platform").game()
local p = game.ActorPos(220)
if p then print(("%s at %.1f, %.1f, %.1f facing %d"):format(p.name, p.x, p.y, p.z, game.ActorHeading(220))) end
local aliveBefore = not game.ActorDead(220)
w.world.actors[220] = nil                           -- the boar despawns
game.BeginTick()                                    -- a new frame (EB's pulse does this every frame)

-- check
DOCS.eq(aliveBefore, true, "alive before")
DOCS.eq(game.ActorDead(220), true, "gone from the zone counts as dead")
DOCS.eq(game.ActorPos(220), nil, "and has no position")
DOCS.eq(game.ActorHeading(220), nil, "nor a heading")
