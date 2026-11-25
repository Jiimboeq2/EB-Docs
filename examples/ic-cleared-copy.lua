-- Spot a reset that did not take
--
-- After each lap the loop checks the nameds it reached: when every one was already gone ("skipped:gate"), the lap ran a copy that was still cleared, so its reset did not take. ic.clearedCopy says why and the loop ends instead of cycling an empty copy.
--
-- kind:      snippet
-- expect:    A lap where the named was killed passes; a lap where it was already gone is reported.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.ic
-- id:        ic-cleared-copy

local IC = require("eb.ic")

-- an instance with one named encounter (only the parts clearedCopy reads)
local inst = {
    zone = "Fixture Hollow", short = "fixture_hollow",
    route = { { id = "n1", act = "encounter", name = "captain" }, { id = "t1", act = "encounter", name = "skitters" } },
    _enc = { captain = { kind = "named" }, skitters = { kind = "trash" } },
}

-- your script: the check the loop makes after each lap
local fresh = IC.clearedCopy({ inst = inst, verdicts = { n1 = "killed", t1 = "cleared" } })
local stale = IC.clearedCopy({ inst = inst, verdicts = { n1 = "skipped:gate", t1 = "skipped:gate" } })
print(stale)

-- check
DOCS.eq(fresh, nil, "a lap that killed its named is fine")
DOCS.has(stale, "its reset did not take", "an all-gone lap is reported")
