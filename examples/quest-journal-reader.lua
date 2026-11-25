-- Read a quest's journal lines
--
-- eb.quest.journal reads the quest tracker the way packs need it: lineState(text, quest) answers open, done, gone (the quest is up but its stage moved on) or nil (not on the tracker). A line matches its text inside the objective, else word by word with small typos forgiven.
--
-- kind:      snippet
-- expect:    The open, done and gone lines read as such; a slightly misspelled line still matches; an untracked quest reads nil.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.quest.journal
-- id:        quest-journal-reader

local Journal = require("eb.quest.journal")

-- a reader: the game's quest tracker rows (EB's game layer supplies these in game)
local reader = {
    trackerRows = function()
        return { { name = "The Fixture Reeds", parts = {
            { text = "Gather three fixture reeds", progress = { current = 1, total = 3 } },
            { text = "Speak to Warden Fixturo", progress = { complete = true } } } } }
    end,
}
local J = Journal.new(reader)

local open = J:lineState("Gather three fixture reeds", "The Fixture Reeds")
print("Gather three fixture reeds -> " .. open)

DOCS.eq(open, "open", "1 of 3: still open")
DOCS.eq(J:lineState("Speak to Warden Fixturo", "The Fixture Reeds"), "done", "a checked line")
DOCS.eq(J:lineState("Return to the docks", "The Fixture Reeds"), "gone", "the quest is up but no part holds it")
DOCS.eq(J:lineState("Gather thre fixture reed", "The Fixture Reeds"), "open", "small typos are forgiven")
DOCS.eq(J:lineState("Anything", "Another Quest"), nil, "a quest the tracker does not show")
DOCS.check(J:questActive("The Fixture Reeds"), "the quest is on the tracker")
DOCS.eq(#J:openLines("The Fixture Reeds"), 1, "one unfinished objective")
DOCS.check(Journal.lineHolds("Collect 3 fixture reeds (1/3)", "fixture reeds"), "lineHolds: text inside an objective")
