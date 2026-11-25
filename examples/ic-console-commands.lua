-- The instance commands from the console
--
-- Boot EB offline and type the instance commands the way you would in game: eb ic status, eb lockouts and eb resetzone. Each answers at once; a run itself is an EB task that eb ic status reports on. Resetting a zone (and reading which zones you are saved to) is held back until EB has proven that call in the game: the answer names the zone and says so.
--
-- kind:      snippet
-- expect:    eb ic status says the runner is idle, eb lockouts answers, and eb resetzone names the zone and says its reset is held back until it is proven live; with no zone it asks which.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   commands.ic, eb.app.ic
-- id:        ic-console-commands

-- offline stand-in: the whole of EB for InnerSpace booted by its real boot
local a = DOCS.app()

-- your script: lines exactly as you type them
local status = a.console("eb ic status")
local locks = a.console("eb lockouts")
local reset = a.console("eb resetzone one fixture_hollow")
print(status)
print(reset)

-- check
DOCS.has(status, "ic: idle", "no run is going")
DOCS.has(locks, "lockouts:", "eb lockouts answers")
DOCS.has(reset, "the reset of fixture_hollow", "eb resetzone names the zone it was asked for")
DOCS.has(reset, "held back until it is proven live", "and says the reset is held back for now")
DOCS.has(a.console("eb resetzone"), "which zone?", "with no zone it asks which")
a.stop()
