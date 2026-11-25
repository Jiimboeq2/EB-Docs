-- EB tested example: Meter the game's own combat lines
-- monitor-feed-from-events | snippet | topics: combat, events, helpers
--
-- What it does:  parse_feed.attach wires a parser to eb.events: each combat line that reaches ChatLine is read, counted and
--                re-announced as a CombatEvent; a zone change ends the fight.
-- Tested:        Two combat lines are counted and announced; a plain chat line is ignored; zoning closes the fight.
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
local Feed = require("eb.ui.monitor.parse_feed")
local Parser = require("eb.ui.monitor.parser")
local parser = Parser.new({ me = "Fixturae" })
local seen, closed = 0, nil
events.on(Feed.EVENTS.COMBAT_EVENT, function() seen = seen + 1 end)
events.on(Feed.EVENTS.ENCOUNTER, function(e) closed = e.reason end)
local detach = Feed.attach({ events = events, parser = parser, combatlog = require("eb.ui.monitor.combatlog") })

-- the game delivers lines (offline: the fake host fires ISXEQ2's chat event, then the zone events)
w.host:emitChat({ chatType = 3, message = "YOUR Fixture Flare hits a fixture brute for 1000 points of heat damage." })
w.host:emitChat({ chatType = 3, message = "YOU hit a fixture brute for 500 points of slashing damage." })
w.host:emitChat({ chatType = 8, speaker = "Tankard", message = "nice pull" })
w.frame(2)
local dmg = parser:current().total.dmg
w.host:fire("EQ2_FinishedZoning", "4")
w.frame(2)
print(("counted %d records, %d damage; fight closed: %s"):format(seen, dmg, tostring(closed)))
detach()

-- check
DOCS.eq(seen, 2, "two records announced")
DOCS.eq(dmg, 1500, "both hits counted")
DOCS.eq(closed, "zone", "the zone change closed the fight")
DOCS.eq(parser:current(), nil, "no fight is open after zoning")
