-- Wait inside a task
--
-- Work that waits runs as a pulse task: eb.delay(ms) pauses the task, never the game's frame.
--
-- kind:      snippet
-- expect:    The task waits 1 second in two steps while the frames go on; it records three marks in order.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.platform
-- id:        platform-pulse-task-wait

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()

-- your script
local P = require("eb.platform")
local pulse = P.pulse()
local marks, started = {}, P.now()
pulse.spawn("docs.slow-errand", function(task)
    marks[#marks + 1] = "start"
    eb.delay(500)                        -- yields this task; the frame (and every other job) keeps running
    marks[#marks + 1] = "half"
    eb.delay(500)
    marks[#marks + 1] = "end"
end)

local framesWhileWaiting = 0
pulse.every("docs.count-frames", 0, function() framesWhileWaiting = framesWhileWaiting + 1 end)
w.runUntil(function() return #marks == 3 end, 5000)
print(("task done after %.1f s"):format((P.now() - started) / 1000))

-- check
DOCS.eq(table.concat(marks, ","), "start,half,end", "the steps ran in order")
DOCS.check(P.now() - started >= 1000, "the two waits took their time")
DOCS.check(framesWhileWaiting > 50, "frames kept coming while the task waited")
DOCS.check(not pulse.running("docs.slow-errand"), "the task is finished")
