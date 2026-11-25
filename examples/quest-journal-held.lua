-- EB tested example: Is a quest on the tracker?
-- quest-journal-held | snippet | topics: quests
--
-- What it does:  A journal view reads the quest tracker through any reader with trackerRows(). J:rows() gives every tracked quest
--                and its objectives; J:questHeld(name) says whether a quest is tracked - and answers nil, not false, when the
--                tracker reads empty and it cannot tell.
-- Tested:        The tracked quest is held, another is not, and an empty tracker cannot tell.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
