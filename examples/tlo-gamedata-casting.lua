-- Read the cast bars through GetGameData
--
-- Me.GetGameData[key].Label reads a value the game's own interface shows. Spells.Casting is your cast bar; ImpliedTarget.Casting is the spell your (implied) target is casting.
--
-- kind:      snippet
-- expect:    Both labels read in one batch; the game layer's CastingName() and TargetCasting() answer the same.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        tlo-gamedata-casting

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
