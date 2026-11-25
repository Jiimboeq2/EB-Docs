-- EB tested example: Spot a reset that did not take
-- ic-cleared-copy | snippet | topics: instances, tasks
--
-- What it does:  After each lap the loop checks the nameds it reached: when every one was already gone ("skipped:gate"), the lap
--                ran a copy that was still cleared, so its reset did not take. ic.clearedCopy says why and the loop ends instead
--                of cycling an empty copy.
-- Tested:        A lap where the named was killed passes; a lap where it was already gone is reported.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
