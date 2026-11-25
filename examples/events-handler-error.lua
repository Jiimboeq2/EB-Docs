-- EB tested example: A handler that fails never stops the others
-- events-handler-error | snippet | topics: events, helpers
--
-- What it does:  Every handler runs protected: one that raises is counted, keeps its place, and the other handlers of the same
--                event still run.
-- Tested:        The failing handler is counted once per event and the healthy handler still sees every line.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local events = w.events()

-- your script
local seen = 0
events.on("IncomingText", function() error("this handler has a bug") end)
events.on("IncomingText", function() seen = seen + 1 end)
local before = events.stats.totalHandlerFailures

w.host:emitText("Line one.")
w.frame(2)
w.host:emitText("Line two.")
w.frame(2)

-- check
DOCS.eq(seen, 2, "the healthy handler heard both lines")
DOCS.eq(events.stats.totalHandlerFailures - before, 2, "the failing one was counted each time")
