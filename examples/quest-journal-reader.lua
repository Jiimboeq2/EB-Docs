-- EB tested example: Read a quest's journal lines
-- quest-journal-reader | snippet | topics: quests, helpers
--
-- What it does:  eb.quest.journal reads the quest tracker the way packs need it: lineState(text, quest) answers open, done, gone
--                (the quest is up but its stage moved on) or nil (not on the tracker). A line matches its text inside the
--                objective, else word by word with small typos forgiven.
-- Tested:        The open, done and gone lines read as such; a slightly misspelled line still matches; an untracked quest reads
--                nil.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
