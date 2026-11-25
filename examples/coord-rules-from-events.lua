-- EB tested example: A rule that listens to the game
-- coord-rules-from-events | snippet | topics: helpers, events, crew
--
-- What it does:  bindEvents feeds a rules engine from eb.events: a tell or an emote line triggers a crew rule, and the intent
--                becomes one eb command line.
-- Tested:        The emote line in chat triggers the rule; its crew intent carries "eb all pause".
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

-- your script
local P = require("eb.platform")
local Coord = require("eb.coord.rules")
local coord = Coord.new({ me = { box = "is1", name = "Fixturae", role = "tank" }, clock = P.now })
local lines = {}
coord:onIntent(function(it) if it.kind == "crew" then lines[#lines + 1] = it.line end end)
coord:add({ id = "pause-on-roar", trigger = { kind = "chat", match = "lets out a deafening roar" },
            action = { kind = "crew", line = "eb all pause" }, scope = "self" })
coord:bindEvents(events)
P.pulse().every("coord.tick", 100, function(now) coord:tick(now) end)   -- delays, gates and embargo expiry

-- the game delivers the emote (offline: the fake host fires ISXEQ2's chat event)
w.host:emitChat({ chatType = 15, speaker = "Overseer of Fixtures", speakerIsNPC = true,
                  message = "The Overseer of Fixtures lets out a deafening roar!" })
w.frame(3)
print("crew line: " .. tostring(lines[1]))

-- check
DOCS.eq(#lines, 1, "one crew intent")
DOCS.eq(lines[1], "eb all pause", "the rule's command line")
