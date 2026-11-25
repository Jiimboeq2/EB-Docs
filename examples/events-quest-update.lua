-- EB tested example: Follow a quest's progress
-- events-quest-update | snippet | topics: events, quests
--
-- What it does:  QuestOffered and QuestUpdated deliver the quest's name and the game's own update text, the text a quest pack's
--                stages advance on.
-- Tested:        The handler records the offer and the update text in order.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local events = w.events()

-- your script
local seen = {}
events.on("QuestOffered", function(ev) seen[#seen + 1] = "offered " .. ev.name end)
events.on("QuestUpdated", function(ev)
    seen[#seen + 1] = ev.name .. ": " .. ev.progress
    print(seen[#seen])
end)

w.host:fire("EQ2_onQuestOffered", "Fixture Lanterns", "Light the lanterns of the hollow.", "20", "0")
w.frame(2)
w.host:fire("EQ2_onQuestUpdate", "4242", "Fixture Lanterns", "fixture_hollow", "Hollow", "Light the lanterns.",
    "1/3 lanterns lit")
w.frame(2)

-- check
DOCS.eq(seen[1], "offered Fixture Lanterns", "the offer")
DOCS.eq(seen[2], "Fixture Lanterns: 1/3 lanterns lit", "the update text")
