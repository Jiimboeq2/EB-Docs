-- React to a chat line
--
-- Subscribe to ChatLine, let the game deliver a tell, and handle it on EB's next frame.
--
-- kind:      snippet
-- expect:    The handler sees the tell's speaker and text once, after the frame that delivered it.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.events
-- id:        events-chat-line

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local events = w.events()        -- in game EB's boot has already attached the game's events and ticks them

-- your script
local heard = {}
events.on("ChatLine", function(ev)
    -- runs from EB's frame pulse, never inside the game's own event callback: reading the game here is fine
    heard[#heard + 1] = ev
    print(("heard %s: %s"):format(ev.speaker, ev.message))
end)

-- the game delivers a tell (offline: the fake host fires ISXEQ2's chat event)
w.host:emitChat({ chatType = 28, speaker = "Friendo", message = "are you ready?" })
w.frame(2)

-- check
DOCS.eq(#heard, 1, "one line delivered")
DOCS.eq(heard[1].speaker, "Friendo", "the speaker")
DOCS.eq(heard[1].category, 28, "the chat category number")
