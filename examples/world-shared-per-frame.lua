-- One snapshot per frame, shared by everyone
--
-- Every caller in the same frame gets the SAME snapshot table, so the brain and every window share one read.
--
-- kind:      snippet
-- expect:    Two calls in one frame return the same table; the next frame reads fresh and sees the change.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.world, game
-- id:        world-shared-per-frame

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
