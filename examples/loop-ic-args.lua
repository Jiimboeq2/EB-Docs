-- Loop windows and the reset decision
--
-- eb ic loop <file> [minutes] [difficulty]: no minutes (or 0) loops until stopped. parseLoopArgs splits the line, loopMinutes picks the window (the command line over the file's loop.max_minutes), and decide says what the tank does between laps: reset now, wait the timer out, or end because the wait outlasts the window.
--
-- kind:      snippet
-- expect:    The line splits into file, minutes and difficulty; the three decisions come out reset, wait and end.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.ic
-- id:        loop-ic-args

local IC = require("eb.ic")
local a = assert(IC.parseLoopArgs("fixture_hollow 480 [Heroic I]"))
print(("%s for %d min at %s"):format(a.file, a.minutes, a.difficulty))
local forever = assert(IC.parseLoopArgs("fixture_hollow"))

DOCS.eq(a.minutes, 480, "minutes")
DOCS.eq(a.difficulty, "[Heroic I]", "the rest of the line is the difficulty")
DOCS.eq(forever.minutes, 0, "no minutes = 0 = until stopped")
DOCS.eq(select(2, IC.parseLoopArgs("")), IC.LOOP_USAGE, "an empty line answers the usage")
DOCS.eq(IC.loopMinutes({ loop = { max_minutes = 90 } }, {}), 90, "the file's window when the line names none")
DOCS.eq(IC.loopMinutes({ loop = { max_minutes = 90 } }, { minutes = 30 }), 30, "the line wins")
-- decide(seconds until the copy can be reset, minutes left in the loop; -1 = uncapped)
DOCS.eq(IC.decide(0, 60), "reset", "the timer is up: reset now")
DOCS.eq(IC.decide(600, -1), "wait", "an uncapped loop waits out any timer")
DOCS.eq(IC.decide(7200, 30), "end", "a 2 h wait past a 30 min window ends the loop")
