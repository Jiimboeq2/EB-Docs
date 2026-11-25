-- EB tested example: Time something with the platform clock
-- platform-clock-now | snippet | topics: helpers, perf
--
-- What it does:  P.now() is milliseconds that only go forward: measure how long something took without os.time.
-- Tested:        Measures the time across 30 frames (480 ms on the offline world) with P.now(), eb.now() and P.seconds().
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
