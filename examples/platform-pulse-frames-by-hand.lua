-- Drive EB's frames yourself
--
-- With no frame loop running, pulse.frame(now) runs one frame at a time: jobs on their interval, a task's wait, the stop flag and the cleanups - the way to test a helper offline, exactly.
--
-- kind:      snippet
-- expect:    Over 10 frames of 50 ms the 100 ms job runs 5 times and the task wakes after its 250 ms wait; stop then cleanup runs the onStop handler.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.platform
-- id:        platform-pulse-frames-by-hand

-- offline stand-in: a world with NO frame loop of its own (pulse = false), so this script drives every frame
local w = DOCS.world({ pulse = false })

-- your script
local P = require("eb.platform")
local pulse = P.pulse()
local said = {}
pulse.setLog(function(line) said[#said + 1] = line end)     -- the pulse's own messages, captured
pulse.bindEb(eb)                                             -- eb.delay waits on this pulse

local runs, doneAt, cleaned = 0, nil, nil
pulse.every("count", 100, function(now) runs = runs + 1 end)
pulse.spawn("wait-a-bit", function()
    eb.delay(250)                                            -- a wait is fine inside a task
    doneAt = P.now()
end)
pulse.onStop("my.helper", function(why) cleaned = why end)

local t = 0
P.clock().use(function() return t end)
for i = 1, 10 do t = i * 50; pulse.frame(t) end
pulse.stop("test over")
local stopping, why = pulse.stopping()
pulse.cleanup()
print(("job ran %d times, task done at %d ms, stopping: %s (%s)"):format(runs, doneAt, tostring(stopping), why))

-- check
DOCS.eq(runs, 5, "a 100 ms job over 500 ms of frames")
DOCS.eq(doneAt, 300, "the task woke on the first frame after its wait")
DOCS.eq(cleaned, "test over", "cleanup ran the onStop handler with the reason")
DOCS.eq(pulse.otherRunning(t), false, "after cleanup no EB counts as running here")
DOCS.eq(#said, 0, "no job raised and no task ran slow")
