-- A quest that goes into an instance, in a group
--
-- When a pack's CheckZone names an instance and the box is a group member (not the driver), it waits in the hub at a barrier for the tank to zone the group in. It never walks the instance's route itself. The driver goes on.
--
-- kind:      snippet
-- expect:    The member answers working and waits at the hub barrier; the driver's same step goes on.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.quest
-- id:        quest-instance-member

local PACK = { schema = "eb-quest/1", quest_name = "Fixture Depths",
               steps = { { type = "command", command = 'CheckZone "Fixture Hollow: Heroic"' } } }

local function firstStatus(amDriver)
    local deps, world = require("quests.lib.questworld").make({ zone = "Fixture Docks", groupCount = 3,
        amDriver = amDriver })
    local quests = require("eb.quest").bind(deps)
    local st, info = quests.step(quests.start({ quest = PACK, name = PACK.quest_name }, {}))
    return st, info, world
end

local stM, infoM, wM = firstStatus(false)
print(infoM)
local stD = firstStatus(true)

DOCS.eq(stM, "working", "the member waits")
DOCS.has(infoM, "waiting for the tank", "for the tank to zone the group in")
DOCS.eq(wM.did("barrier"), 1, "at a crew barrier in the hub")
DOCS.eq(wM.did("walk") + wM.did("travel"), 0, "and moves nowhere on its own")
DOCS.check(stD == "need_travel" or stD == "working", "the driver goes on")
