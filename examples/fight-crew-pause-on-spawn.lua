-- EB tested example: Pause the crew when the named appears
-- fight-crew-pause-on-spawn | snippet | topics: fights, events, crew, helpers
--
-- What it does:  Watch for the named from a cheap pulse job, raise your own event on the edge, and turn it into ONE deliberate
--                crew line: everyone pauses.
-- Tested:        No line while the room is empty; when the named spawns the event fires once and "eb pause" goes to all boxes.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game EB sets the relay to the crew)
local w = DOCS.world()
local events = w.events()
local sent = {}
events.setRelay(function(targets, line) sent[#sent + 1] = { targets, line } end)

-- your script
local game = require("eb.platform").game()
local wasUp = false
require("eb.platform").pulse().every("named watch", 500, function()          -- one query every half second
    local up = game.NearestActor(nil, 80, "ashen overseer") ~= nil
    if up and not wasUp then events.emit("NamedUp", { name = "the Ashen Overseer" }) end   -- your own event
    wasUp = up
end)
events.on("NamedUp", function(ev)
    events.crew("all", "eb pause")             -- events never travel by themselves: this is the one line sent
    print("to all: eb pause (" .. ev.name .. ")")
end)

w.runFor(1200)
local quiet = #sent
w.addActor({ id = 300, name = "the Ashen Overseer", type = "NamedNPC", distance = 40 })   -- offline: it spawns
w.runFor(1200)

-- check
DOCS.eq(quiet, 0, "nothing while the room is empty")
DOCS.eq(#sent, 1, "one crew line when it appears")
DOCS.eq(sent[1][1], "all", "to every box")
DOCS.eq(sent[1][2], "eb pause", "the pause command")
