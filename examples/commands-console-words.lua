-- A console word of your own
--
-- eb.console is the console window's model: register a word it answers itself, run lines, and read what a window draws - the newest row, the word list and this box's own row.
--
-- kind:      snippet
-- expect:    The new word is answered by the console; any other line goes to the dispatch; the word list grew once.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.console
-- id:        commands-console-words

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
