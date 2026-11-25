-- Run a job on a timer
--
-- A pulse job runs fn(now) on its interval, inside the frame. Cancel it by name.
--
-- kind:      snippet
-- expect:    A 500 ms job runs 4 times in 2 seconds of frames, then stops once cancelled.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.platform
-- id:        platform-pulse-job

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
