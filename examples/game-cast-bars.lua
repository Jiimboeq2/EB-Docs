-- EB tested example: Read what you and your target are casting, and cancel
-- game-cast-bars | snippet | topics: game, combat, fights
--
-- What it does:  CastingName() is your own cast bar; TargetCasting() is your target's spell name and id; CancelCast() stops your
--                cast.
-- Tested:        Reads both cast bars, then cancels your own cast.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
