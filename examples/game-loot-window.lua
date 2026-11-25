-- Read the loot window without polling it
--
-- LootWindow() reads nothing while no loot window is believed open; the game's own loot event says when one opens, and only then is it read.
--
-- kind:      snippet
-- expect:    Twenty quiet frames cost at most one idle read; after the loot event the window and its item count are read.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-loot-window

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.world.stats.lootReadsNoWindow = 0               -- the fake world counts the slow "is a loot window up" reads

-- your script
local game = require("eb.platform").game()
for _ = 1, 20 do game.BeginTick(); game.LootWindow() end      -- quiet frames: nothing open
local quiet = w.world.stats.lootReadsNoWindow
-- a corpse is opened: the game raises its loot event, then the window is there
w.setWindow("loot", { type = "Free For All", items = { { name = "a fixture pelt" }, { name = "a fixture fang" } } })
w.host:fire("EQ2_onLootWindowAppeared", "1001")
game.BeginTick()
local lw = game.LootWindow()
if lw then print(("loot window: %s, %d items"):format(lw.type, lw.items)) end

-- check
DOCS.check(quiet <= 1, "at most one idle read in twenty quiet frames")
DOCS.eq(lw and lw.items, 2, "two items in the window")
