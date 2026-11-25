-- EB tested example: A console word of your own
-- commands-console-words | snippet | topics: commands, ui
--
-- What it does:  eb.console is the console window's model: register a word it answers itself, run lines, and read what a window
--                draws - the newest row, the word list and this box's own row.
-- Tested:        The new word is answered by the console; any other line goes to the dispatch; the word list grew once.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local Console = require("eb.console")
local C = Console.new({ box = "is1", name = "Fixturae", clock = function() return 0 end,
    dispatch = function(line) return true, "ran " .. line end })      -- in game: eb.dispatch
local rev0 = C.vocabRev()
C.register("roll", function(args) return true, "rolled " .. tostring(args[1]) end, "roll a die")
local _, rolled = C.run("roll 20")
local _, ran = C.run("eb status")
C.setSelfState({ zone = "fixture_hollow", mode = "idle", hp = 100, pw = 90 })
local words = {}
for _, v in ipairs(C.vocabData()) do words[#words + 1] = v.verb end
print(("%s | %s | words: %s"):format(rolled, ran, table.concat(words, ", ")))

-- check
DOCS.check(C.vocabRev() > rev0, "registering a word moved the word list's revision")
DOCS.eq(words[#words], "roll", "your word comes last, after the built-in ones")
DOCS.check(C.newest() >= 2, "the output holds the rows the two lines made")
DOCS.eq(C.boxes()[1].state.zone, "fixture_hollow", "this box's own row (first in the box list)")
DOCS.eq(C.state().boxes[1].zone, "fixture_hollow", "and in the state a window draws")
