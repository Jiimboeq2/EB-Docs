-- Hold an ability for a while
--
-- An embargo rule puts an ability on hold for 20 seconds when a line is said; the cast stack asks holdsCast before casting, and the hold ends on its own.
--
-- kind:      snippet
-- expect:    Fixture Blast is held after the warning line, still held at 19 s, free again at 21 s; a lift ends a hold early.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.coord.rules
-- id:        coord-embargo-hold

-- your script
local Coord = require("eb.coord.rules")
local now = 0
local coord = Coord.new({ me = { box = "is1", name = "Fixturae", role = "mage" }, clock = function() return now end })
coord:add({ id = "no-blast", trigger = { kind = "chat", match = "reflects all spells" },
            action = { kind = "embargo", ability = "Fixture Blast", durationMs = 20000 }, scope = "self" })
coord:add({ id = "blast-again", trigger = { kind = "chat", match = "shield shatters" },
            action = { kind = "liftembargo", ability = "Fixture Blast" }, scope = "self" })

coord:feed({ kind = "chat", text = "The Overseer of Fixtures reflects all spells!" })
local a = coord:holdsCast("Fixture Blast")
now = 19000; coord:tick(); local b = coord:holdsCast("Fixture Blast")
now = 21000; coord:tick(); local c = coord:holdsCast("Fixture Blast")
print(("held: %s at 0 s, %s at 19 s, %s at 21 s"):format(tostring(a), tostring(b), tostring(c)))

-- a second warning, then the lift line ends it early
coord:feed({ kind = "chat", text = "It reflects all spells again" })
local up = #coord:activeEmbargoes()
coord:feed({ kind = "text", text = "Its shield shatters." })

-- check
DOCS.check(a and b and not c, "held for its 20 seconds, then free")
DOCS.eq(up, 1, "one embargo up after the second warning")
DOCS.eq(coord:holdsCast("Fixture Blast"), false, "the lift line ended it at once")
DOCS.eq(coord:holdsCast("Fixture Strike"), false, "other abilities are never held")
