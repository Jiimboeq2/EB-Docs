-- Understand a group loot method however it is typed
--
-- grouploot.findMethod(words) and findRarity(words) accept every spelling a person types ("lol", "Leader Only", "need before greed", "fabled and above"); said(method, rarity) gives the game's own words.
--
-- kind:      snippet
-- expect:    Two spellings name the same method, and the method plus a rarity reads back in the game's words.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.grouploot
-- id:        econ-group-loot-words

-- your script
local GL = require("eb.economy.grouploot")
local m1, m2 = GL.findMethod("lol"), GL.findMethod("Leader Only")
local fabled = GL.findRarity("fabled and above")
print(GL.said(m1, fabled))
local ok, method, rarity = GL.parseWords({ "need", "before", "greed", "treasured" })

-- check
DOCS.eq(m1.word, m2.word, "two spellings, one method")
DOCS.eq(GL.findMethod("pizza"), nil, "not a method")
DOCS.eq(ok, true, "a method and a rarity in one line")
DOCS.eq(method.label .. " / " .. rarity.label, "Need Before Greed / treasured items and above", "the game's words")
