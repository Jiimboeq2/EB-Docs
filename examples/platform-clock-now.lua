-- Time something with the platform clock
--
-- P.now() is milliseconds that only go forward: measure how long something took without os.time.
--
-- kind:      snippet
-- expect:    Measures the time across 30 frames (480 ms on the offline world) with P.now(), eb.now() and P.seconds().
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.platform
-- id:        platform-clock-now

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()

-- your script
local P = require("eb.platform")
local started = P.now()                 -- ms; eb.now() is the same clock on the eb global
w.frame(30)                             -- (offline: 30 frames of 16 ms pass; in game, time just passes)
local elapsed = P.now() - started
print(("elapsed %d ms (%.2f s)"):format(elapsed, P.seconds() - started / 1000))

-- check
DOCS.eq(elapsed, 480, "30 frames of 16 ms")
DOCS.eq(eb.now(), P.now(), "eb.now() is the platform clock")
DOCS.check(P.now() >= started, "the clock never steps back")
