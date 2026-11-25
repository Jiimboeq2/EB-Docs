-- Run a command from a script in a running EB
--
-- The running EB is eb.app; eb.dispatch(line) runs a line through the same registry a typed one uses.
--
-- kind:      snippet
-- expect:    eb.dispatch answers eb status; app.status() says what came up; pause and resume flip the brain.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.app, eb.registry
-- id:        commands-app-dispatch

-- offline stand-in: the whole of EB for InnerSpace booted by its real boot (in game it is already running)
local a = DOCS.app()

-- your script
local ok, text = eb.dispatch("eb status")
print(text:match("eb%-app 1 on isx"))
local lines = eb.app.status()                    -- { lines }: version, what is up, what is not and why
eb.dispatch("eb pause")
local paused = eb.app.brain.paused
eb.dispatch("eb resume")

-- check
DOCS.check(ok, "eb status ran")
DOCS.has(lines[1], "eb-app 1 on isx", "the first status line")
DOCS.eq(eb.app.stages.registry, "up", "the registry stage came up")
DOCS.eq(paused, true, "eb pause paused the brain")
DOCS.check(not eb.app.brain.paused, "eb resume let it go")
a.stop()
