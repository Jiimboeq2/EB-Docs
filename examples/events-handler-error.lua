-- A handler that fails never stops the others
--
-- Every handler runs protected: one that raises is counted, keeps its place, and the other handlers of the same event still run.
--
-- kind:      snippet
-- expect:    The failing handler is counted once per event and the healthy handler still sees every line.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.events
-- id:        events-handler-error

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
