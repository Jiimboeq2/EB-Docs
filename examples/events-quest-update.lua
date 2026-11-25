-- Follow a quest's progress
--
-- QuestOffered and QuestUpdated deliver the quest's name and the game's own update text, the text a quest pack's stages advance on.
--
-- kind:      snippet
-- expect:    The handler records the offer and the update text in order.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.events
-- id:        events-quest-update

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
