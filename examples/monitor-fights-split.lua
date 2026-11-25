-- One fight ends, the next begins
--
-- A quiet gap longer than idleMs ends a fight; breakEncounter ends one on purpose (EB does on a zone change); snapshot lists the past fights, newest first.
--
-- kind:      snippet
-- expect:    Three fights: two split by the quiet gap, one by breakEncounter; the snapshot lists the two past fights.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.ui.monitor.parser
-- id:        monitor-fights-split

-- your script
local Parser = require("eb.ui.monitor.parser")
local parser = Parser.new({ me = "Fixturae", idleMs = 5000 })
parser:setFriends({ "Tankard", "Mendwell" })            -- the crew: always friends
parser:addFriend("Sparkwick")
local function hit(t, amount)
    return parser:ingest({ t = t, kind = "hit", src = "Fixturae", dst = "a fixture brute", amount = amount })
end
hit(0, 100); hit(2000, 100)                -- fight 1
hit(20000, 300)                            -- 18 s later: fight 2
parser:breakEncounter()                    -- ended on purpose (a zone change)
local third = hit(21000, 50)               -- fight 3, live

local snap = parser:snapshot()
print(("fights %d, past %d, live fight %d"):format(snap.fights, #snap.encounters, snap.current.id))

-- check
DOCS.eq(third, 3, "ingest answers the fight a record went into")
DOCS.eq(snap.encounters[1].id, 2, "newest past fight first")
DOCS.eq(snap.encounters[2].total.dmg, 200, "fight 1's damage")
DOCS.check(parser:isFoe("a fixture brute"), "a name with a leading 'a' is a mob")
DOCS.check(not parser:isFoe("Mendwell"), "a single word is taken for a player")
local past = parser:viewEncounter(parser.history[1])
DOCS.eq(past.total.dmg, 200, "viewEncounter reads a past fight")
DOCS.check(not parser:isFoe("Sparkwick"), "a friend added by name")
parser:reset()
DOCS.eq(parser:snapshot().fights, 0, "reset forgets every fight")
