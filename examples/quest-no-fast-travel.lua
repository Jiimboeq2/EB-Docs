-- EB tested example: Packs never fast travel
-- quest-no-fast-travel | snippet | topics: quests, nav
--
-- What it does:  Inside a pack the destination is always reached the ground way: SmartTravelTo hands the zone back as need_travel
--                (the zone's own transit), FastTravel is refused with the reason, and a flight-only step (FlyUp) stops because EB
--                never flies: it walks the zone's mesh and nothing else.
-- Tested:        SmartTravelTo answers need_travel; FastTravel and FlyUp are blocked with their reasons (EB never flies).
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
