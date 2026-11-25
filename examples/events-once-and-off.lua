-- A one-time handler, and unsubscribing
--
-- Use { once = true } for a handler that should run only for the next event, and off() to stop one.
--
-- kind:      snippet
-- expect:    The once-handler runs for the first line only; after off() the other handler hears nothing more.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.events
-- id:        events-once-and-off

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
