-- EB tested example: Save where a quest is, and resume there
-- quest-resume-pointer | snippet | topics: quests, data
--
-- What it does:  After a step finishes, quests.pointer(run) is the resume point to keep: { step, zone, x, y, z }.
--                quests.resume(handle, pointer) starts a fresh run at that step, so a restart never repeats the steps already
--                done.
-- Tested:        The pointer after two steps is step 3; the resumed run walks only the last waypoint.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
