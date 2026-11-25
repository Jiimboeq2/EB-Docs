-- EB tested example: Pause, resume, status and the kill switch
-- commands-core-family | snippet | topics: commands, helpers
--
-- What it does:  The core commands every box answers, typed in the console and run from a script with eb.dispatch: help's usage
--                line, pause and resume, status goal, and eb stopall halting the brain.
-- Tested:        pause freezes the brain and resume frees it; a script's eb.dispatch takes the same path; stopall halts the brain
--                while EB stays loaded.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: the whole of EB for InnerSpace booted by its real boot (in game you type in the console)
local a = DOCS.app()

-- your script: lines as typed, then the same from code
local usage = a.console("eb help pause"):match("eb pause[^\n]*")
local paused = a.console("eb pause")
local wasPaused = a.app.brain.paused
local okR, resumed = eb.dispatch("eb resume")              -- a script runs a line exactly as if typed
local goal = a.console("eb status goal")
local halted = a.console("eb stopall")
print(("%s | %s | %s | %s"):format(usage, paused:match("EB paused"), resumed, halted:match("the brain is halted")))

-- check
DOCS.check(wasPaused == true, "eb pause froze the brain")
DOCS.check(okR and a.app.brain.paused == false, "eb.dispatch ran eb resume")
DOCS.has(goal, "brain:", "eb status goal names the brain's state")
DOCS.check(a.app.brain.halted == true, "eb stopall halted the brain")
a.stop()
DOCS.check(a.said("EB stopped"), "typed eb stop ends EB on this box")
