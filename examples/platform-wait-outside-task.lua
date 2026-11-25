-- EB tested example: Never wait in a job or a handler
-- platform-wait-outside-task | snippet | topics: helpers, perf
--
-- What it does:  A job, an event handler or a command handler must return at once: waiting there raises. Let a task wait.
-- Tested:        eb.delay inside a job raises (caught here); the same work handed to a task waits and finishes.
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
local refused, finished = nil, false
pulse.every("docs.impatient", 100, function()
    pulse.cancel("docs.impatient")
    local ok, err = pcall(eb.delay, 200)             -- WRONG: a job cannot wait
    if not ok then refused = tostring(err) end
    -- RIGHT: hand the waiting part to a task
    pulse.spawn("docs.patient", function()
        eb.delay(200)
        finished = true
    end)
end)
w.runFor(1000)
print("refused: " .. tostring(refused):match("eb%.delay called outside an EB task"))

-- check
DOCS.has(refused, "outside an EB task", "the wait in a job was refused with its reason")
DOCS.check(finished, "the task did the waiting")
