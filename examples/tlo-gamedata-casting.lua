-- EB tested example: Read the cast bars through GetGameData
-- tlo-gamedata-casting | snippet | topics: tlos, combat, fights
--
-- What it does:  Me.GetGameData[key].Label reads a value the game's own interface shows. Spells.Casting is your cast bar;
--                ImpliedTarget.Casting is the spell your (implied) target is casting.
-- Tested:        Both labels read in one batch; the game layer's CastingName() and TargetCasting() answer the same.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.self.castingName = "Fixture Mend"
w.addActor({ id = 290, name = "a fixture shaman", distance = 14, castId = 4242, castName = "Fixture Blast" })
w.self.targetId = 290

-- your script
local raw = IS.Parse("${Me.GetGameData[Spells.Casting].Label}|${Me.GetGameData[ImpliedTarget.Casting].Label}")
local mine, theirs = raw:match("^([^|]*)|([^|]*)$")
print(("me: %s / target: %s"):format(mine, theirs))

-- check
local game = require("eb.platform").game()
DOCS.eq(game.CastingName(), mine, "the game layer's own cast bar read")
DOCS.eq((game.TargetCasting()), theirs, "and the target's")
