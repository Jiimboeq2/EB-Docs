-- EB tested example: Read your target
-- game-target-read | snippet | topics: game, combat
--
-- What it does:  Target() answers your target as one plain table - name, type, health, distance, level, the named flag, and what
--                it is targeting - from the same read as Me().
-- Tested:        Prints the target line, then checks the named flag and that no target reads as nil.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addActor({ id = 210, name = "Overseer of Fixtures", type = "NamedNPC", level = 102, healthPct = 88,
    distance = 12, targetId = 1 })
w.self.targetId = 210

-- your script
local game = require("eb.platform").game()
local t = game.Target()
if t then
    print(("target: %s (%s) hp %d%% at %.1f m"):format(t.name, t.type, t.healthPct, t.distance))
    if t.isNamed and t.targetId == game.Me().id then print("the named is on me") end
end

-- check
DOCS.eq(t.isNamed, true, "a NamedNPC reads as named")
DOCS.eq(t.targetId, 1, "it targets me (my id is 1 offline)")
w.self.targetId = 0
game.BeginTick()                       -- EB's frame pulse starts a fresh tick every frame
DOCS.eq(game.Target(), nil, "no target is nil, never an empty table")
