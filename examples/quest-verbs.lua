-- What a pack can say: the verb list
--
-- eb.quest knows every verb a pack may use. supported(verb) answers yes or no, ported() lists each verb with what it does and its group, refused() lists the verbs EB refuses on purpose with the reason. A line with a verb nobody handles stops the run with a clear reason; it is never guessed or skipped.
--
-- kind:      snippet
-- expect:    HailActor is supported, a made-up verb is not, and running it stops the pack with "not handled".
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.quest
-- id:        quest-verbs

local Q = require("eb.quest")
local ported, refused = Q.ported(), Q.refused()
local groups = {}
for _, v in ipairs(ported) do groups[v.group] = (groups[v.group] or 0) + 1 end

local deps = require("quests.lib.questworld").make()
local quests = Q.bind(deps)
local run = quests.start({ quest = { schema = "eb-quest/1", quest_name = "Fixture Verbs",
    steps = { { type = "command", command = 'FrobnicateLever "a fixture lever"' } } }, name = "Fixture Verbs" }, {})
local st, why = quests.step(run)
print("FrobnicateLever -> " .. st)

DOCS.check(Q.supported("HailActor"), "HailActor is a pack verb")
DOCS.check(Q.supported("mm"), "verbs match in any case")
DOCS.check(not Q.supported("FrobnicateLever"), "a made-up verb is not")
DOCS.check(#ported > 200, "hundreds of verbs are ported")
DOCS.check(groups.npc and groups.travel and groups.quest, "grouped by concern: npc, travel, quest ...")
DOCS.check(#refused > 5, "the refused ones are listed with their reason")
DOCS.eq(st, "blocked", "an unknown verb stops the run")
DOCS.has(why, "not handled", "and says why")
