-- EB tested example: Wait for the journal to move on
-- quest-wait-for-journal | snippet | topics: quests, events
--
-- What it does:  WaitForQuestStep "<quest>","<line>",<seconds> holds the pack (status working, never a blocking wait) until the
--                journal shows that line, or ticks it. At the time limit the step is blocked, or with -continue it says so and
--                goes on.
-- Tested:        The wait reports working until the escort NPC's line shows up 15 s in, then the pack goes on; a wait that never
--                sees its line is blocked at its limit.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local PACK = {
    schema = "eb-quest/1", quest_name = "Fixture Escort", continues_later = true,
    steps = {
        { type = "command", command = 'WaitForQuestStep "Fixture Escort","Speak to the ferryman",60' },
        { type = "command", command = "HailActor a fixture ferryman" },
    },
}
local deps, world = require("quests.lib.questworld").make()
world.journal.give("Fixture Escort", { "Escort the ferryman to the pier" })

local quests = require("eb.quest").bind(deps)
local run = quests.start({ quest = PACK, name = PACK.quest_name }, {})
local waited, status = 0, nil
for _ = 1, 30 do
    status = quests.step(run)
    if status ~= "working" then break end
    waited = waited + 1
    world.tick(5000)
    if world.now >= 15000 then world.journal.add("Fixture Escort", "Speak to the ferryman") end   -- the escort arrives
end
repeat status = quests.step(run) until status == "complete" or status == "blocked"
print(("waited %d tick(s) for the journal"):format(waited))

-- a wait whose line never comes: blocked at its limit (10 s here)
local deps2, world2 = require("quests.lib.questworld").make()
world2.journal.give("Fixture Escort", { "Escort the ferryman to the pier" })
local q2 = require("eb.quest").bind(deps2)
local run2 = q2.start({ quest = { schema = "eb-quest/1", quest_name = "Fixture Escort", steps = {
    { type = "command", command = 'WaitForQuestStep "Fixture Escort","Speak to the ferryman",10' } } },
    name = "Fixture Escort" }, {})
local st2, why2
for _ = 1, 10 do st2, why2 = q2.step(run2); if st2 ~= "working" then break end; world2.tick(5000) end

DOCS.eq(waited, 3, "working while the line was missing (0 s, 5 s, 10 s)")
DOCS.eq(status, "complete", "then the pack went on")
DOCS.eq(world.did("hail"), 1, "and hailed the ferryman")
DOCS.eq(st2, "blocked", "no line in time: blocked")
DOCS.has(why2, "after 10s", "with the limit in the reason")
