-- Test a script with a fake service
--
-- P.install(target, service, adapter) hands the platform a stand-in: test a script against a clock you step.
--
-- kind:      snippet
-- expect:    A hand-stepped clock replaces the real one; the script under test sees exactly the times it is given.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.platform
-- id:        platform-test-with-a-fake

-- your script: a tiny cooldown helper that reads the platform clock
local P = require("eb.platform")
local function cooldown(ms)
    local readyAt = P.now() + ms
    return function() return P.now() >= readyAt end
end

-- the test: pin the target, hand in a fake clock, step it
P.reset()
P.use("isx")
local fake = { t = 1000 }
P.install("isx", "clock", { now = function() return fake.t end, seconds = function() return fake.t / 1000 end,
                            wall = function() return nil end })
local ready = cooldown(2000)
local early = ready()
fake.t = 3000
print(("cooldown ready at %d ms"):format(P.now()))

-- check
DOCS.eq(early, false, "not ready before its time")
DOCS.eq(ready(), true, "ready once the clock reaches it")
P.reset()                                        -- forget the fake: the next script gets the real services
DOCS.check(P.get("clock") ~= nil, "the platform answers again after a reset")
