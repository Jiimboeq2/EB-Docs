-- Pause, resume, status and the kill switch
--
-- The core commands every box answers, typed in the console and run from a script with eb.dispatch: help's usage line, pause and resume, status goal, and eb stopall halting the brain.
--
-- kind:      snippet
-- expect:    pause freezes the brain and resume frees it; a script's eb.dispatch takes the same path; stopall halts the brain while EB stays loaded.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   commands.core, eb.app
-- id:        commands-core-family

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
