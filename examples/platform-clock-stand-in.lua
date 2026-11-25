-- Drive the clock in a test
--
-- clock.use hands EB's clock a source you step; the clock never runs backwards - when its source steps back it holds - and seconds() is the same clock.
--
-- kind:      snippet
-- expect:    1000, then 1000 again when the source steps back, then 3000; P.now() reads the same clock.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   clock, eb.platform
-- id:        platform-clock-stand-in

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()

-- your script: a clock you step by hand
local P = require("eb.platform")
local clock = P.clock()
local t = 1000
clock.use(function() return t end)
local a = clock.now()
t = 500                                     -- the source jumps back (a clock was set)
local b = clock.now()                       -- EB's clock holds
t = 2500
local c = clock.now()                       -- and moves on from where it held
print(("now %d -> %d (source stepped back) -> %d"):format(a, b, c))

-- check
DOCS.eq(b, a, "never backwards")
DOCS.eq(c, 3000, "it carries on by the source's own steps")
DOCS.eq(P.now(), c, "P.now() is the same clock")
DOCS.eq(clock.seconds(), 3, "seconds() is now() / 1000")
local stamp = clock.wall()
DOCS.check(stamp == nil or type(stamp) == "number", "wall() is a number of seconds, or nil")
