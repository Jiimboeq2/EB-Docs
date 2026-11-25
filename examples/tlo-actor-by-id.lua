-- Read an actor by its id
--
-- Actor[id,N] is the fast, exact way to read one actor; the game layer reads it through ActorPos / ActorDead / ActorTarget, once per frame however often you ask.
--
-- kind:      snippet
-- expect:    Reads the mob by id directly and through the game layer; both agree, and asking again in the same frame reads nothing more.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        tlo-actor-by-id

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addActor({ id = 220, name = "a fixture boar", level = 98, distance = 7.5, targetId = 1 })

-- your script
local raw = IS.Parse("${Actor[id,220].Name}|${Actor[id,220].Level}|${Actor[id,220].Distance}|${Actor[id,220].Target.ID}")
local name, lvl, dist, tid = raw:match("^([^|]*)|([^|]*)|([^|]*)|([^|]*)$")
print(("%s lvl %s, %s m, targeting id %s"):format(name, lvl, dist, tid))
local game = require("eb.platform").game()
game.BeginTick()
local p = game.ActorPos(220)
local reads = game.GameDataReads()
game.ActorPos(220); game.ActorDead(220)            -- the same frame: answered from the first read

-- check
DOCS.eq(p.name, name, "the game layer reads the same actor")
DOCS.eq(game.GameDataReads(), reads, "no extra read in the same frame")
DOCS.eq(tonumber(tid), 1, "its target is me")
