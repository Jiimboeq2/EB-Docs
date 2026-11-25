-- The same line twice is delivered once
--
-- The game often repeats a chat line once per chat window; eb.events delivers a repeat inside 1.5 seconds only once, and counts it.
--
-- kind:      snippet
-- expect:    Two identical tells in a row reach the handler once; a different line is delivered.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.events
-- id:        events-dedupe

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local events = w.events()

-- your script
local heard = {}
events.on("ChatLine", function(ev) heard[#heard + 1] = ev.message end)
local before = events.stats.totalDeduped

w.host:emitChat({ chatType = 28, speaker = "Friendo", message = "pull when ready" })
w.host:emitChat({ chatType = 28, speaker = "Friendo", message = "pull when ready" })   -- the same line again
w.frame(2)
w.host:emitChat({ chatType = 28, speaker = "Friendo", message = "go" })
w.frame(2)

-- check
DOCS.eq(#heard, 2, "two distinct lines delivered")
DOCS.eq(heard[1], "pull when ready", "the first")
DOCS.eq(heard[2], "go", "then the next one")
DOCS.eq(events.stats.totalDeduped - before, 1, "the repeat was counted as a duplicate")
