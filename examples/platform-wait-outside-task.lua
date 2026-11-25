-- Never wait in a job or a handler
--
-- A job, an event handler or a command handler must return at once: waiting there raises. Let a task wait.
--
-- kind:      snippet
-- expect:    eb.delay inside a job raises (caught here); the same work handed to a task waits and finishes.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.platform
-- id:        platform-wait-outside-task

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
