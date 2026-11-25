-- EB tested example: Understand a group loot method however it is typed
-- econ-group-loot-words | snippet | topics: items, crew, loot
--
-- What it does:  grouploot.findMethod(words) and findRarity(words) accept every spelling a person types ("lol", "Leader Only",
--                "need before greed", "fabled and above"); said(method, rarity) gives the game's own words.
-- Tested:        Two spellings name the same method, and the method plus a rarity reads back in the game's words.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
