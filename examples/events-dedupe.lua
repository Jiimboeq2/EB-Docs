-- EB tested example: The same line twice is delivered once
-- events-dedupe | snippet | topics: events
--
-- What it does:  The game often repeats a chat line once per chat window; eb.events delivers a repeat inside 1.5 seconds only
--                once, and counts it.
-- Tested:        Two identical tells in a row reach the handler once; a different line is delivered.
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
