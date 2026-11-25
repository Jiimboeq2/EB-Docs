-- Save where a quest is, and resume there
--
-- After a step finishes, quests.pointer(run) is the resume point to keep: { step, zone, x, y, z }. quests.resume(handle, pointer) starts a fresh run at that step, so a restart never repeats the steps already done.
--
-- kind:      snippet
-- expect:    The pointer after two steps is step 3; the resumed run walks only the last waypoint.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.quest
-- id:        quest-resume-pointer

local PACK = {
    schema = "eb-quest/1", quest_name = "Fixture Rounds",
    steps = {
        { type = "command", command = "MM 1,0,1" },
        { type = "command", command = "MM 2,0,2" },
        { type = "command", command = "MM 3,0,3" },
    },
}
local handle = { quest = PACK, name = PACK.quest_name }

local deps, world = require("quests.lib.questworld").make()
local quests = require("eb.quest").bind(deps)
local run = quests.start(handle, {})
quests.step(run); quests.step(run)                -- two steps done
local pointer = quests.pointer(run)               -- keep this (write it OFF the game thread)
print("resume at step " .. pointer.step)

-- later (a reload, a new session): a fresh world and a fresh runner
local deps2, world2 = require("quests.lib.questworld").make()
local quests2 = require("eb.quest").bind(deps2)
local resumed = quests2.resume(handle, pointer)
local status
repeat status = quests2.step(resumed) until status == "complete" or status == "blocked"

DOCS.eq(pointer.step, 3, "the next step to run")
DOCS.eq(world.did("walk"), 2, "the first run walked two waypoints")
DOCS.eq(status, "complete", "the resumed run finishes")
DOCS.eq(world2.did("walk"), 1, "and walks only the step that was left")
