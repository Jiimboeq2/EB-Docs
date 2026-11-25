-- EB tested example: React to a chat line
-- events-chat-line | snippet | topics: events, helpers
--
-- What it does:  Subscribe to ChatLine, let the game deliver a tell, and handle it on EB's next frame.
-- Tested:        The handler sees the tell's speaker and text once, after the frame that delivered it.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
