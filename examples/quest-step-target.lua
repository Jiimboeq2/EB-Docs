-- Where does the current step want the character?
--
-- quests.stepTarget(run) reads the step about to run: x, y, z (and its zone) for a move, the zone for a travel step, { actor, zone } for a step about an NPC. A map window or the brain can show or pre-plan it without running the step.
--
-- kind:      snippet
-- expect:    The move step answers its point, the travel step its zone, and the hail step its actor.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.quest
-- id:        quest-step-target

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
