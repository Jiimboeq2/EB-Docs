-- EB tested example: Read an actor by its id
-- tlo-actor-by-id | snippet | topics: tlos, game
--
-- What it does:  Actor[id,N] is the fast, exact way to read one actor; the game layer reads it through ActorPos / ActorDead /
--                ActorTarget, once per frame however often you ask.
-- Tested:        Reads the mob by id directly and through the game layer; both agree, and asking again in the same frame reads
--                nothing more.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
