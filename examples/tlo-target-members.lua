-- EB tested example: Target members, and what NULL looks like
-- tlo-target-members | snippet | topics: tlos, combat
--
-- What it does:  ${Target.Name} and friends read your target. With no target the whole chain reads NULL - no error - which the
--                game layer turns into nil.
-- Tested:        Reads the target's members in one read; with no target the same read answers NULL and Target() is nil.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
