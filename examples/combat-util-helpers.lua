-- EB tested example: The engine's small helpers
-- combat-util-helpers | snippet | topics: combat, helpers
--
-- What it does:  require("eb.combat").U holds the pure helpers the engine uses - tag lists, kill time, valid mobs, AE entries,
--                the encounter count, decisions, the lowest member, word matches, ability-line keys and safe optional calls.
-- Tested:        Each helper answers as the engine reads it.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script (pure Lua: no game needed)
local U = require("eb.combat").U

local tags = U.splitTags(" ae; Dumbfire ;")
local eta = U.killEta(100, 75, 10000)                       -- lost 25% in 10 s: 75% left = 30 s
local stalled = U.killEta(80, 80, 10000)                    -- nothing came off: math.huge
local live = U.validMob({ id = 7, isNPC = true, healthPct = 50 })
local corpse = U.validMob({ id = 7, isNPC = true, healthPct = 0 })
local ae = U.isAE({ tags = "CA;AE" })
local splash = U.isAE({ tags = "CA", gates = { minEncounterSize = 3 } })
local count = U.mobCount({ engagedCount = 4 }, { encounterSize = 2 })
local d = U.decision("dps", { ability = "Fixture Strike" }, "Target", "by hand")
local who, low = U.lowestOf({ { name = "Member1", healthPct = 70 }, { name = "Member2", healthPct = 35 } })
local guardish = U.anyWord("Captain of the Gate Watchman", { "watchman", "sentry" })
local key = U.lineKey("Fixture Blast III")
local present = U.fn({ ping = function() return "pong" end }, "ping")
local answer = U.call({ ping = function(x) return x * 2 end }, "ping", 21)
local absent = U.call({}, "missing")
print("helpers ok")

-- check
DOCS.eq(table.concat(tags, ","), "AE,DUMBFIRE", "tags trimmed and upper case")
DOCS.eq(eta, 30000, "the kill time from two readings")
DOCS.eq(stalled, math.huge, "no progress: never")
DOCS.eq(live, true, "a living NPC with an id")
DOCS.eq(corpse, false, "not a corpse")
DOCS.eq(ae, true, "an AE-tagged entry")
DOCS.eq(splash, true, "an encounter-size gate over 1 counts as AE")
DOCS.eq(count, 4, "the encounter as the # gate counts it")
DOCS.eq(d.ability, "Fixture Strike", "a decision carries its entry's ability")
DOCS.eq(who.name, "Member2", "the member who needs a heal most")
DOCS.eq(low, 35, "and their health")
DOCS.eq(guardish, true, "a word match on part of the text")
DOCS.eq(key, "fixture blast", "the rank numeral dropped")
DOCS.check(type(present) == "function", "an optional function that is there")
DOCS.eq(answer, 42, "called safely")
DOCS.eq(absent, nil, "and nil for one that is not")
