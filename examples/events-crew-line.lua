-- Turn an event into one command for the crew
--
-- Events never travel to the other boxes by themselves: a handler that wants the crew to act sends ONE deliberate eb line with events.crew().
--
-- kind:      snippet
-- expect:    The announcement of a named makes the handler send exactly one "eb pause" line to every box.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.events
-- id:        events-crew-line

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local events = w.events()
local sent = {}
-- in game EB sets the sender to its crew relay at start; offline we record what would be sent
events.setRelay(function(targets, line) sent[#sent + 1] = targets .. " " .. line end)

-- your script
events.on("Announcement", function(ev)
    if ev.text:find("Overseer of Fixtures", 1, true) then
        events.crew("all", "eb pause")       -- one line, on purpose; every box runs it once
    end
end)

w.host:fire("EQ2_onAnnouncement", "The Overseer of Fixtures stirs!", "alert", "5")
w.frame(2)
w.host:fire("EQ2_onAnnouncement", "A fixture brute wanders off.", "", "0")
w.frame(2)

-- check
DOCS.eq(#sent, 1, "one crew line")
DOCS.eq(sent[1], "all eb pause", "to every box")
