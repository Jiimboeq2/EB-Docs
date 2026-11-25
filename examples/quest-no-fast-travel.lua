-- Packs never fast travel
--
-- Inside a pack the destination is always reached the ground way: SmartTravelTo hands the zone back as need_travel (the zone's own transit), FastTravel is refused with the reason, and a flight-only step (FlyUp) stops because EB never flies: it walks the zone's mesh and nothing else.
--
-- kind:      snippet
-- expect:    SmartTravelTo answers need_travel; FastTravel and FlyUp are blocked with their reasons (EB never flies).
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.quest
-- id:        quest-no-fast-travel

local function once(line)
    local deps = require("quests.lib.questworld").make({ zone = "Fixture Docks" })
    local quests = require("eb.quest").bind(deps)
    local run = quests.start({ quest = { schema = "eb-quest/1", quest_name = "Fixture Travel",
        steps = { { type = "command", command = line } } }, name = "Fixture Travel" }, {})
    return quests.step(run)
end

local s1, info1 = once('SmartTravelTo "Fixture Vale"')
local s2, info2 = once('FastTravel "Fixture Vale"')
local s3, info3 = once("FlyUp")
print("FastTravel -> " .. s2)

DOCS.eq(s1, "need_travel", "SmartTravelTo takes the ground way")
DOCS.eq(info1, "Fixture Vale", "to the zone the step names")
DOCS.eq(s2, "blocked", "FastTravel is refused in a pack")
DOCS.has(info2, "packs never fast travel", "with the reason")
DOCS.eq(s3, "blocked", "a flight-only step stops")
DOCS.has(info3, "EB never flies", "EB never flies: it walks the mesh only")
