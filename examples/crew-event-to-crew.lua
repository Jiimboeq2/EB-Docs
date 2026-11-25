-- EB tested example: Turn one box's event into a crew command
-- crew-event-to-crew | snippet | topics: crew, events, helpers
--
-- What it does:  Events never travel by themselves: a handler sends ONE deliberate line with events.crew(targets, line).
-- Tested:        When the named's emote reaches is1, is1 sends "eb pause" to the others and is2 runs it.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: an offline relay bus between two boxes
local bus = require("eb.relay.events").bus()

-- your script
local events, Relay = require("eb.events"), require("eb.relay")
local me = Relay.new({ box = "is1", name = "Tankard", transport = bus.box("is1") })
local mate = Relay.new({ box = "is2", name = "Mendwell", transport = bus.box("is2") })
local mateRan = {}
mate.onLocal(function(line) mateRan[#mateRan + 1] = line end)
me.join(); mate.join()

events.setRelay(function(targets, line) return me.send(targets .. " " .. line) end)
events.on("IncomingText", function(ev)
    if ev.text:find("roars and the walls shake", 1, true) then events.crew("others", "eb pause") end
end)
events.emit("IncomingText", { text = "The Overseer roars and the walls shake!", type = 0 })
print("is2 ran: " .. tostring(mateRan[1]))

-- check
DOCS.eq(mateRan[1], "eb pause", "the other box got exactly one line")
DOCS.eq(#mateRan, 1, "and only one")
events.setRelay(nil)
DOCS.eq(events.crew("all", "eb pause"), false, "with no relay set, crew() is a harmless no-op")
