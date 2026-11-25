-- EB tested example: Hold an ability for a while
-- coord-embargo-hold | snippet | topics: crew, fights, combat
--
-- What it does:  An embargo rule puts an ability on hold for 20 seconds when a line is said; the cast stack asks holdsCast before
--                casting, and the hold ends on its own.
-- Tested:        Fixture Blast is held after the warning line, still held at 19 s, free again at 21 s; a lift ends a hold early.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
