-- Meter a fight
--
-- Feed stamped combat lines to a parser and read the live fight: damage per second per character, the top character's abilities, and who took damage.
--
-- kind:      snippet
-- expect:    Over a 10-second fight the crew does 6000 damage (600 per second), Fixturae leads, the tank took 900.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.ui.monitor.parser, eb.ui.monitor.combatlog
-- id:        monitor-meter-a-fight

-- your script
local Parser = require("eb.ui.monitor.parser")
local log = require("eb.ui.monitor.combatlog")
local parser = Parser.new({ me = "Fixturae", friends = { "Tankard", "Mendwell" } })

-- a saved fight: "<ms><tab><line>" (in game parse_feed.attach feeds the parser live)
local fight = table.concat({
    "1000\tYOUR Fixture Flare hits a fixture brute for 1200 points of heat damage.",
    "2000\tTankard hits a fixture brute for 1200 points of crushing damage.",
    "3000\tA fixture brute hits Tankard for 900 points of slashing damage.",
    "6000\tYOUR Fixture Flare critically hits a fixture brute for 2400 points of heat damage.",
    "11000\tTankard hits a fixture brute for 1200 points of crushing damage.",
}, "\n")
for _, rec in ipairs(log.parseStamped(fight, { me = "Fixturae" })) do parser:ingest(rec) end

local v = parser:current()
local top = v.bars[1]
print(("%d s: %d dps | %s %d (%d%%) | %s took %d"):format(v.durMs / 1000, v.dps, top.name, top.dmg, top.pct,
    v.intake[1].name, v.intake[1].dmg))

-- check
DOCS.eq(v.total.dmg, 6000, "all outgoing damage")
DOCS.eq(top.name, "Fixturae", "the top damage dealer")
DOCS.eq(v.abilities[1].name, "Fixture Flare", "the top dealer's abilities are listed")
DOCS.eq(v.abilities[1].crits, 1, "one critical")
local named = false
for _, f in ipairs(v.foes) do named = named or f:lower() == "a fixture brute" end
DOCS.check(named, "the foe is listed (names keep the case a line gave them)")
local ex = parser:export()
DOCS.eq(ex.sources.Tankard.dmg, 2400, "export: a flat record of the fight")
