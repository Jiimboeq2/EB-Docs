-- Load a quest pack from its file
--
-- quests.load(path) reads a pack file as pure data (it may not run code) and hands back a handle to start. A file that is a quest line index, not a quest, still loads, but its run is blocked with what it is.
--
-- kind:      snippet
-- expect:    The pack loads with its name and five steps and runs to complete; the line index loads as not runnable.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.quest
-- id:        quest-load-file

local deps, world = require("quests.lib.questworld").make()
local quests = require("eb.quest").bind(deps)

local handle = assert(quests.load("tests/eb/docs_examples/quests/lib/packs/fixture_lanterns.lua"))
print(("loaded %s: %d steps"):format(handle.name, #handle.quest.steps))
local run = quests.start(handle, {})
local status
for _ = 1, 30 do
    status = quests.step(run)
    if status == "complete" or status == "blocked" then break end
    world.tick(1000)
end

-- a quest LINE index (the order of a line's quests) is data too, but it is not a quest
local index = { quest = { schema = "eb-questline/1", name = "Fixture Line" }, name = "Fixture Line",
                notRunnable = "an eb-questline/1 index (the order of a quest line), not a quest: run the line's quests" }
local st, why = quests.step(quests.start(index, {}))

DOCS.eq(handle.quest.quest_name, "The Fixture Lanterns", "the handle carries the pack")
DOCS.eq(status, "complete", "the pack ran to its end")
DOCS.eq(world.did("click"), 2, "both lanterns were clicked")
DOCS.eq(st, "blocked", "an index file is not run")
DOCS.has(why, "not a quest", "and says what it is")
