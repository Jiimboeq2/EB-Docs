-- Pause the crew when the named appears
--
-- Watch for the named from a cheap pulse job, raise your own event on the edge, and turn it into ONE deliberate crew line: everyone pauses.
--
-- kind:      snippet
-- expect:    No line while the room is empty; when the named spawns the event fires once and "eb pause" goes to all boxes.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.events, game, eb.platform
-- id:        fight-crew-pause-on-spawn

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
