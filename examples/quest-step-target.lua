-- EB tested example: Where does the current step want the character?
-- quest-step-target | snippet | topics: quests, nav
--
-- What it does:  quests.stepTarget(run) reads the step about to run: x, y, z (and its zone) for a move, the zone for a travel
--                step, { actor, zone } for a step about an NPC. A map window or the brain can show or pre-plan it without running
--                the step.
-- Tested:        The move step answers its point, the travel step its zone, and the hail step its actor.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local PACK = {
    schema = "eb-quest/1", quest_name = "Fixture Targets",
    steps = {
        { type = "command", command = "MM 10,2,30" },
        { type = "command", command = 'CheckZone "Fixture Vale"' },
        { type = "command", command = "HailActor Warden Fixturo,1" },
    },
}
local deps, world = require("quests.lib.questworld").make({ zone = "Fixture Vale" })
local quests = require("eb.quest").bind(deps)
local run = quests.start({ quest = PACK, name = PACK.quest_name }, {})

local x, y, z = quests.stepTarget(run)                -- step 1: the move
quests.step(run)
local _, _, _, zone = quests.stepTarget(run)          -- step 2: the travel
quests.step(run)
local who = quests.stepTarget(run)                    -- step 3: the hail
print("hail target: " .. who.actor)

DOCS.eq(x, 10, "x"); DOCS.eq(y, 2, "y"); DOCS.eq(z, 30, "z")
DOCS.eq(zone, "Fixture Vale", "a travel step answers its zone")
DOCS.eq(who.actor, "Warden Fixturo", "an NPC step answers { actor }")
