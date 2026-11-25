-- Where an actor stands, and whether it is gone
--
-- ActorPos(id) answers an actor's position, heading and distance; ActorDead(id) is true when it is dead or no longer in the zone; ActorHeading(id) is its facing in degrees, or nil when it is gone.
--
-- kind:      snippet
-- expect:    Reads the mob's position, then calls it dead once it has despawned.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-actor-pos

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
