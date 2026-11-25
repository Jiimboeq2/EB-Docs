-- Read what you and your target are casting, and cancel
--
-- CastingName() is your own cast bar; TargetCasting() is your target's spell name and id; CancelCast() stops your cast.
--
-- kind:      snippet
-- expect:    Reads both cast bars, then cancels your own cast.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-cast-bars

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.self.isCasting, w.self.castingName = true, "Fixture Mend"
w.addActor({ id = 290, name = "a fixture shaman", distance = 14, castId = 4242, castName = "Fixture Blast" })
w.self.targetId = 290

-- your script
local game = require("eb.platform").game()
local mine = game.CastingName()
local label, id = game.TargetCasting()
print(("me: %s; target: %s (%d)"):format(mine, label, id))
if label ~= "" and game.Me().isCasting then game.CancelCast() end    -- e.g. stop a heal to interrupt instead

-- check
DOCS.eq(mine, "Fixture Mend", "your cast bar")
DOCS.eq(id, 4242, "the target's cast id")
DOCS.eq(w.world.commands[#w.world.commands], "/cancel_spellcast", "the cancel went out")
DOCS.eq(game.CastingName(), "", "after the cancel your cast bar is empty")
