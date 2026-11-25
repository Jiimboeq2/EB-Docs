-- EB tested example: Wait inside a task
-- platform-pulse-task-wait | snippet | topics: helpers, perf
--
-- What it does:  Work that waits runs as a pulse task: eb.delay(ms) pauses the task, never the game's frame.
-- Tested:        The task waits 1 second in two steps while the frames go on; it records three marks in order.
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
