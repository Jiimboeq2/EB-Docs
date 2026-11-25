-- EB tested example: Stay inside the per-frame read budget
-- game-read-budget | snippet | topics: game, perf
--
-- What it does:  Me(), Target() and Group() together cost two game reads in a frame, however often they are asked;
--                GameDataReads() counts this frame's reads so a helper can stay under about 8.
-- Tested:        Asking for you, your target and your group five times each in one frame still costs two reads.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addMember({ name = "Tankfixture", id = 11, class = "guardian", healthPct = 90, powerPct = 70, inZone = true })
w.addActor({ id = 11, name = "Tankfixture", type = "PC", isNPC = false, distance = 4 })
w.addActor({ id = 220, name = "a fixture boar", distance = 5 })
w.self.targetId = 220

-- your script
local game = require("eb.platform").game()
game.BeginTick()                                   -- a new frame (EB's pulse does this every frame)
local asks = 0
for _ = 1, 5 do
    game.Me(); game.Target(); game.Group()
    asks = asks + 3
end
local reads = game.GameDataReads()
print(("%d asks, %d reads this frame"):format(asks, reads))

-- check
DOCS.eq(reads, 2, "one read for you and your target, one for the group")
DOCS.check(reads <= 8, "well inside the budget")
