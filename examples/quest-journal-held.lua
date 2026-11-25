-- Is a quest on the tracker?
--
-- A journal view reads the quest tracker through any reader with trackerRows(). J:rows() gives every tracked quest and its objectives; J:questHeld(name) says whether a quest is tracked - and answers nil, not false, when the tracker reads empty and it cannot tell.
--
-- kind:      snippet
-- expect:    The tracked quest is held, another is not, and an empty tracker cannot tell.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.quest.journal
-- id:        quest-journal-held

-- offline stand-in for the game: the quest tracker
local deps, world = require("quests.lib.questworld").make()
world.journal.give("Fixture Lanterns", { "Light the fixture lantern" })

-- your script
local Journal = require("eb.quest.journal")
local J = Journal.new(deps.journal)
for _, row in ipairs(J:rows()) do print(("tracked: %s (%d line)"):format(row.name, #row.parts)) end

-- check
DOCS.eq(J:questHeld("Fixture Lanterns"), true, "the quest is tracked")
DOCS.eq(J:questHeld("Fixture Bells"), false, "another one is not")
world.journal.complete("Fixture Lanterns")
DOCS.eq(J:questHeld("Fixture Bells"), nil, "an empty tracker cannot tell")
DOCS.eq(Journal.new(nil):questHeld("Fixture Lanterns"), nil, "nor can a view with no reader")
