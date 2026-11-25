-- EB tested example: Skip a step on a condition or on the journal
-- quest-conditions | snippet | topics: quests
--
-- What it does:  A step's condition is read before it starts: false plus skip_if_condition_false skips it. SkipIfJournal
--                "<line>",N skips the next N steps when the journal already shows that line done, so a pack resumed mid-quest
--                does not redo work.
-- Tested:        The level-gated walk is skipped at level 100, and the two steps behind SkipIfJournal are skipped because the
--                line is done.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local PACK = {
    schema = "eb-quest/1", quest_name = "Fixture Conditions",
    continues_later = true,              -- the quest is still in the journal when these steps end, on purpose
    steps = {
        { type = "command", command = "MM 1,0,1", condition = "${Me.Level} >= 120", skip_if_condition_false = true },
        { type = "command", command = 'SkipIfJournal "Gather the fixture reeds",2' },
        { type = "command", command = "MM 2,0,2" },
        { type = "command", command = 'ClickActor "a fixture reed"' },
        { type = "command", command = "MM 3,0,3" },
    },
}
local deps, world = require("quests.lib.questworld").make({ level = 100 })
world.journal.give("Fixture Conditions", { "Gather the fixture reeds" })
world.journal.check("Fixture Conditions", "Gather the fixture reeds")      -- that part is already done

local quests = require("eb.quest").bind(deps)
local run = quests.start({ quest = PACK, name = PACK.quest_name }, {})
local status
for _ = 1, 20 do status = quests.step(run); if status == "complete" or status == "blocked" then break end end
print("walks: " .. world.did("walk"))

DOCS.eq(status, "complete", "the pack finishes")
DOCS.eq(world.did("walk"), 1, "only the last walk ran")
DOCS.eq(world.did("click"), 0, "the skipped click never happened")
