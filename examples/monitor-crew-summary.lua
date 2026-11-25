-- EB tested example: Share a fight with the crew
-- monitor-crew-summary | snippet | topics: crew, combat, ui
--
-- What it does:  A box sends the crew one short summary per fight, never its raw lines; the shared service hands every window the
--                same monitor.
-- Tested:        The summary line round-trips; the service answers the monitor it was given.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local Feed = require("eb.ui.monitor.parse_feed")
local Parser = require("eb.ui.monitor.parser")
local service = require("eb.ui.monitor.service")
local parser = Parser.new({ me = "Fixturae" })
parser:ingest({ t = 0, kind = "hit", src = "Fixturae", dst = "a fixture brute", amount = 600 })
parser:ingest({ t = 1000, kind = "heal", src = "Fixturae", dst = "Fixturae", amount = 250 })
parser:ingest({ t = 4000, kind = "hit", src = "Fixturae", dst = "a fixture brute", amount = 300 })

local line = Feed.crewLine("is1", parser:export())     -- send this over the crew relay
local back = Feed.parseCrewLine(line)                  -- what the lead reads from it
print(("%s -> %s did %d"):format(line, back.box, back.dmg))

service.setMonitor(parser)                              -- the one monitor every window reads
local shared = service.monitor()
service.publish({ app = { monitor = parser } })

-- check
DOCS.eq(back.heal, 250, "the summary carries the healing")
DOCS.eq(back.durMs, 4000, "and the fight's length")
DOCS.eq(Feed.parseCrewLine("not a summary"), nil, "anything else is not a summary")
DOCS.eq(shared, parser, "the service hands out the same monitor")
DOCS.eq(service.app().monitor, parser, "the published app carries it too")
service.reset()
