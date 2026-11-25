-- EB tested example: Know when to repair
-- game-gear-condition | snippet | topics: game, items, helpers
--
-- What it does:  WorstCondition() is the lowest condition of anything you wear, in percent; it reads item info (a server request)
--                sparingly and keeps the answer for 30 seconds.
-- Tested:        Finds the worst worn item at 38% and decides a repair is due; a second ask inside 30 s reads nothing.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.world.items = {
    ["Fixture Blade"] = { where = "worn", slot = 1, condition = 80, id = 51 },
    ["Fixture Vest"] = { where = "worn", slot = 3, condition = 38, id = 52 },
}

-- your script
local game = require("eb.platform").game()
local worst = game.WorstCondition()
if worst and worst <= 40 then print(("worst gear %d%%: time to visit a mender"):format(worst)) end
local reads = game.ReadStats().totalReads
game.WorstCondition()                              -- inside 30 s: answered from what it kept

-- check
DOCS.eq(worst, 38, "the vest is the worst")
DOCS.eq(game.ReadStats().totalReads, reads, "the second ask read nothing")
