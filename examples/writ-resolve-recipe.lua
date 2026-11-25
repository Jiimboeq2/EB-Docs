-- Work out which recipe a work-order step asks for
--
-- eb.economy.writs.stripVerb drops the step's leading verb and its progress; resolve() then finds the recipe: a learned answer, a known spelling fix, the exact book name, a partial fix, the name without its article, and last a loose match only when exactly one recipe fits.
--
-- kind:      snippet
-- expect:    Each kind of step text resolves the way the rules say; two loose fits pick nothing; with no book read the text itself is tried once ("unverified").
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.writs
-- id:        writ-resolve-recipe

-- your script (pure: give it the step text and the recipe book rows)
local Writs = require("eb.economy.writs")
local book = {
    { name = "Fixture Lantern" }, { name = "Fixture Spoon" }, { name = "Fixture Longbow" },
    { name = "Fixture Ladle" },
}
local function show(text, learned)
    local recipe, how = Writs.resolve(text, book, learned)
    print(("%-38s -> %s (%s)"):format(text, tostring(recipe), how))
    return recipe, how
end
print(Writs.stripVerb("I need to create Fixture Lantern (0/6)"))
local r1, h1 = show("Create Fixture Lantern (0/6)")
local r2, h2 = show("Craft Fixture Long Bow")               -- a partial spelling fix: Long Bow -> Longbow
local r3, h3 = show("I need to create a Fixture Spoon")     -- the article comes off
local r4, h4 = show("Make Lantern")                         -- a loose match: exactly one recipe fits
local r5, h5 = show("Make Fixture L")                       -- two fit (Lantern, Ladle): none is picked
local r6, h6 = show("Make the odd thing", { ["the odd thing"] = "Fixture Ladle" })   -- learned last time
local r7, h7 = Writs.resolve("Create Fixture Bowl", nil)     -- the book did not read

-- check
DOCS.eq(r1 .. "/" .. h1, "Fixture Lantern/exact", "exact")
DOCS.eq(r2 .. "/" .. h2, "Fixture Longbow/partial", "partial fix")
DOCS.eq(r3 .. "/" .. h3, "Fixture Spoon/trimmed", "article trimmed")
DOCS.eq(r4 .. "/" .. h4, "Fixture Lantern/loose", "one loose fit")
DOCS.eq(r5, nil, "two loose fits pick nothing")
DOCS.eq(h5, "ambiguous", "and say why")
DOCS.eq(r6 .. "/" .. h6, "Fixture Ladle/learned", "a learned answer wins")
DOCS.eq(r7 .. "/" .. h7, "Fixture Bowl/unverified", "no book: try the text once")
