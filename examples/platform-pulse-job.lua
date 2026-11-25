-- EB tested example: Run a job on a timer
-- platform-pulse-job | snippet | topics: helpers, perf
--
-- What it does:  A pulse job runs fn(now) on its interval, inside the frame. Cancel it by name.
-- Tested:        A 500 ms job runs 4 times in 2 seconds of frames, then stops once cancelled.
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
local pulse = require("eb.platform").pulse()
local runs = 0
pulse.every("docs.heartbeat", 500, function(now)
    runs = runs + 1                      -- a job is ONE short call per run: read, decide, queue - never wait here
end)

w.runFor(2000)                           -- (offline: 2 seconds of frames)
print(("heartbeat ran %d times"):format(runs))
local before = runs
pulse.cancel("docs.heartbeat")
w.runFor(2000)

-- check
DOCS.eq(before, 4, "every 500 ms over 2 s: four runs")
DOCS.eq(runs, before, "a cancelled job runs no more")
