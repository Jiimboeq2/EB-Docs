-- EB tested example: The instance commands from the console
-- ic-console-commands | snippet | topics: instances, commands
--
-- What it does:  Boot EB offline and type the instance commands the way you would in game: eb ic status, eb lockouts and eb
--                resetzone. Each answers at once; a run itself is an EB task that eb ic status reports on. Resetting a zone (and
--                reading which zones you are saved to) is held back until EB has proven that call in the game: the answer names
--                the zone and says so.
-- Tested:        eb ic status says the runner is idle, eb lockouts answers, and eb resetzone names the zone and says its reset is
--                held back until it is proven live; with no zone it asks which.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
