-- EB tested example: Turn an event into one command for the crew
-- events-crew-line | snippet | topics: events, crew, helpers
--
-- What it does:  Events never travel to the other boxes by themselves: a handler that wants the crew to act sends ONE deliberate
--                eb line with events.crew().
-- Tested:        The announcement of a named makes the handler send exactly one "eb pause" line to every box.
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
