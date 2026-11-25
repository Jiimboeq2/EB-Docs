-- Know when to repair
--
-- WorstCondition() is the lowest condition of anything you wear, in percent; it reads item info (a server request) sparingly and keeps the answer for 30 seconds.
--
-- kind:      snippet
-- expect:    Finds the worst worn item at 38% and decides a repair is due; a second ask inside 30 s reads nothing.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-gear-condition

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
