-- Target members, and what NULL looks like
--
-- ${Target.Name} and friends read your target. With no target the whole chain reads NULL - no error - which the game layer turns into nil.
--
-- kind:      snippet
-- expect:    Reads the target's members in one read; with no target the same read answers NULL and Target() is nil.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        tlo-target-members

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addActor({ id = 220, name = "a fixture boar", healthPct = 77, distance = 5 })
w.self.targetId = 220

-- your script
local raw = IS.Parse("${Target.Name}|${Target.Health}|${Target.Distance}|${Target.Type}")
local name, hp, dist, kind = raw:match("^([^|]*)|([^|]*)|([^|]*)|([^|]*)$")
print(("%s %s%% %s %s"):format(name, hp, dist, kind))
w.self.targetId = 0                                -- no target
local none = IS.Parse("${Target.ID}")

-- check
DOCS.eq(name, "a fixture boar", "the name")
DOCS.eq(tonumber(dist), 5, "a distance is text with decimals")
DOCS.eq(none, "NULL", "no target reads NULL, not an error")
local game = require("eb.platform").game()
game.BeginTick()
DOCS.eq(game.Target(), nil, "the game layer answers nil for NULL")
