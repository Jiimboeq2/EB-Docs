-- EB tested example: Ask an ability export what a character can do
-- export-reader-queries | snippet | topics: data, combat, helpers
--
-- What it does:  Wrap an export with reader.load (or read a saved one back with reader.loadText) and ask it by name - any rank
--                finds the line - by group, by label, or for the cast-stack shortlist. Here the export is converted from a few
--                invented records, saved as text and read back the way a helper would read a file.
-- Tested:        The heal is found by a rank name, its labels say heal, the passive is left off the shortlist, and the saved text
--                reads back the same.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local reader = require("eb.exports.reader")
local util = require("eb.exports.util")

-- an export to read (offline: converted from invented records; in game take one from exporter.snapshot)
local ex0 = require("eb.exports.convert_v3").convert({ meta = { subClass = "templar" }, abilities = {
    { Name = "Fixture Mend III", ID = 103, Level = 40, SpellBookType = 0, TargetType = 1, IsBeneficial = true,
      EffectDesc1 = "Heals target for 900 to 1100 hit points" },
    { Name = "Fixture Smite", ID = 201, Level = 12, SpellBookType = 1, DoesDmg = true,
      EffectDesc1 = "Inflicts 400 divine damage on target" },
    { Name = "Fixture Calm", ID = 301, Level = 20, SpellBookType = 4, EffectDesc1 = "Increases max power by 2%" },
} }, { anonymize = true })
local text = util.serialize(ex0)                     -- what you would write to a file (off the game thread)

-- your script: read it back and ask it
local ex = reader.loadText(text)
local mend = ex:find("Fixture Mend")
local heals = 0
for e in ex:iter() do if ex:labels(e).heal then heals = heals + 1 end end
local shortlist = ex:castStackCandidates()
print(("book: %d entries, %d heal, %d on the cast-stack shortlist"):format(ex:summary().total, heals, #shortlist))

-- check
DOCS.eq(mend.name, "Fixture Mend", "found whatever the rank")
DOCS.check(ex:has("Fixture Mend II"), "a rank name finds the same line")
DOCS.check(ex:labels("Fixture Mend").heal, "its labels say heal")
DOCS.eq(#ex:abilities(), 2, "the active abilities")
DOCS.eq(#shortlist, 2, "the passive is not on the shortlist")
DOCS.eq(ex:meta().archetype, "priest", "the header")
DOCS.eq(ex:summary().aa, 1, "the passive counts as an alternate-advancement entry")
DOCS.eq(reader.load(ex0):find("Fixture Smite").topLevel, 12, "load wraps a table you already have")
