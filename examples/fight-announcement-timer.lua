-- EB tested example: Time a mechanic from an announcement
-- fight-announcement-timer | snippet | topics: fights, events
--
-- What it does:  Center-screen announcements arrive as the Announcement event with their text and timer; schedule your answer for
--                just before the timer runs out.
-- Tested:        The announcement's 6 s timer schedules the move for 1 s before it ends, and it fires then, not before.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.events()

-- your script
local events = require("eb.events")
local P = require("eb.platform")
local due, moved

events.on("Announcement", function(ev)
    if ev.text:find("Ashen Storm", 1, true) and ev.timer then
        due = P.now() + (ev.timer - 1) * 1000            -- one second of margin
        print(("move at +%.1f s"):format(ev.timer - 1))
    end
end)
P.pulse().every("storm watch", 100, function(now)       -- a job: cheap, never waits
    if due and now >= due then moved, due = now, nil end
end)

local t0 = P.now()
w.host:fire("EQ2_onAnnouncement", "The Ashen Storm gathers!", "alert", 6)   -- offline: the game shows it
w.runFor(3000)
local early = moved
w.runFor(3000)

-- check
DOCS.eq(early, nil, "not before its time")
DOCS.check(moved ~= nil, "it fired")
DOCS.near((moved - t0) / 1000, 5.0, 0.3, "about a second before the timer ran out")
