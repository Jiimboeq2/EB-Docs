-- EB tested example: One snapshot per frame, shared by everyone
-- world-shared-per-frame | snippet | topics: perf, ui
--
-- What it does:  Every caller in the same frame gets the SAME snapshot table, so the brain and every window share one read.
-- Tested:        Two calls in one frame return the same table; the next frame reads fresh and sees the change.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ pulse = false, me = { healthPct = 90 } })

-- your script
local game = require("eb.platform").game()
local world = require("eb.world").new({ game = game })
local a = world.snapshot()
local b = world.snapshot()                     -- the same frame: no read at all
w.self.healthPct = 40                          -- (offline: the game moves on)
w.frame(1)                                     -- the next frame
world.beginTick()                              -- EB's pulse does this at the start of a frame
local c = world.snapshot()
print(("same frame: %s; next frame: hp %d"):format(a == b and "same table" or "two tables", c.hpPct))

-- check
DOCS.check(a == b, "one table per frame")
DOCS.eq(a.hpPct, 90, "the first frame's health")
DOCS.eq(c.hpPct, 40, "a fresh read on the next frame")
