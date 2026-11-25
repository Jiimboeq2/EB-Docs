-- EB tested example: Run a command from a script in a running EB
-- commands-app-dispatch | snippet | topics: commands, helpers
--
-- What it does:  The running EB is eb.app; eb.dispatch(line) runs a line through the same registry a typed one uses.
-- Tested:        eb.dispatch answers eb status; app.status() says what came up; pause and resume flip the brain.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
