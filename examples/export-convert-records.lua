-- Fold per-rank ability records into an ability export
--
-- An ability list arrives with one record per rank. convert folds every rank of a line into one entry - the highest held rank kept, the lowest level as when the line was learned - labels it, and masks big damage numbers in the effect text. convertText does the same from JSON text with your decoder.
--
-- kind:      snippet
-- expect:    Two ranks of the heal fold into one entry labelled heal, learned at 10 and held at 25; the damage art is labelled dps and its big number is masked.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.exports.convert_v3
-- id:        export-convert-records

local convert = require("eb.exports.convert_v3")

-- one record per rank, in the record layout (offline: invented abilities)
local doc = { meta = { subClass = "templar" }, abilities = {
    { Name = "Fixture Mend", ID = 101, Level = 10, SpellBookType = 0, TargetType = 1, IsBeneficial = true,
      CastingTime = 1.5, RecastTime = 10, MaxRange = 25, EffectDesc1 = "Heals target for 120 to 150 hit points" },
    { Name = "Fixture Mend II", ID = 102, Level = 25, SpellBookType = 0, TargetType = 1, IsBeneficial = true,
      CastingTime = 1.5, RecastTime = 10, MaxRange = 25, EffectDesc1 = "Heals target for 310 to 380 hit points" },
    { Name = "Fixture Smite", ID = 201, Level = 12, SpellBookType = 1, TargetType = 1, DoesDmg = true,
      EffectDesc1 = "Inflicts 12,500 divine damage on target" },
} }

-- your script
local ex = convert.convert(doc, { anonymize = true })
local mend, smite
for _, e in ipairs(ex.abilities) do
    if e.name == "Fixture Mend" then mend = e elseif e.name == "Fixture Smite" then smite = e end
end
print(("%s: learned %d, held %d (%s), %s"):format(mend.name, mend.level, mend.topLevel, mend.rank,
    mend.labels.heal and "heal" or "-"))
local fromText = convert.convertText('{"abilities":[{"Name":"Fixture Ward","ID":7,"Level":5,"SpellBookType":0}]}',
    { decode = require("ebkit.jsontable").decode, anonymize = true })

-- check
DOCS.eq(#ex.abilities, 2, "two ranks folded into one line, plus the art")
DOCS.eq(mend.topLevel, 25, "the highest rank is held")
DOCS.eq(mend.level, 10, "the lowest level is when the line was learned")
DOCS.check(mend.labels.heal, "the heal is labelled heal")
DOCS.check(smite.labels.dps, "the art is labelled dps")
DOCS.has(smite.effects[1], "N divine damage", "a big number is masked in the kept text")
DOCS.eq(ex.meta.character, nil, "anonymize leaves the character out")
DOCS.eq(ex.meta.archetype, "priest", "the subclass gives the archetype")
DOCS.eq(fromText.abilities[1].name, "Fixture Ward", "convertText reads JSON with your decoder")
