-- EB tested example: Test a script with a fake service
-- platform-test-with-a-fake | snippet | topics: helpers, data
--
-- What it does:  P.install(target, service, adapter) hands the platform a stand-in: test a script against a clock you step.
-- Tested:        A hand-stepped clock replaces the real one; the script under test sees exactly the times it is given.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
