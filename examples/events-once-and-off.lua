-- EB tested example: A one-time handler, and unsubscribing
-- events-once-and-off | snippet | topics: events
--
-- What it does:  Use { once = true } for a handler that should run only for the next event, and off() to stop one.
-- Tested:        The once-handler runs for the first line only; after off() the other handler hears nothing more.
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
local first, every = {}, {}
events.on("IncomingText", function(ev) first[#first + 1] = ev.text end, { once = true })
local id = events.on("IncomingText", function(ev) every[#every + 1] = ev.text end)

w.host:emitText("You have been hit by a fixture brute.")
w.frame(2)
w.host:emitText("You feel refreshed.")
w.frame(2)
events.off("IncomingText", id)          -- stop listening
w.host:emitText("You feel tired.")
w.frame(2)

-- check
DOCS.eq(#first, 1, "the once-handler ran one time")
DOCS.eq(first[1], "You have been hit by a fixture brute.", "for the first line")
DOCS.eq(#every, 2, "the other handler heard two lines before off()")
