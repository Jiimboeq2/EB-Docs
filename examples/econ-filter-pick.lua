-- Pick items from a list with a filter
--
-- filter.pick(list, spec) keeps the items that match every criterion you set (tiers, flags, a level band, a class, a name), and tells you why each other item was skipped. An exclude list is never matched.
--
-- kind:      snippet
-- expect:    Picks the two fabled items in the level band, never the excluded one, and says why the rest were skipped.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.filter
-- id:        econ-filter-pick

-- your script: a bag list in EB's item shape (name, tier, level, flags ...)
local F = require("eb.economy.filter")
local bags = {
    { name = "Fixture Gauntlets", tier = "FABLED", level = 75 },
    { name = "Fixture Greaves", tier = "fabled", level = 78 },
    { name = "Fixture Mount Training Scroll", tier = "FABLED", level = 76 },
    { name = "Fixture Bracer", tier = "TREASURED", level = 76 },
    { name = "Fixture Helm", tier = "FABLED", level = 60 },
}
local spec = { tiers = { "fabled" }, minLevel = 70, maxLevel = 80, exclude = { "mount training" } }
local picked, skipped = F.pick(bags, spec)
local names = {}
for _, it in ipairs(picked) do names[#names + 1] = it.name end
print(("picked: %s; skipped %d"):format(table.concat(names, ", "), #skipped))

-- check
DOCS.eq(#picked, 2, "fabled, level 70 to 80")
DOCS.eq(skipped[1].why, "a valuable (never matched)", "the exclude list protects it")
DOCS.eq((F.saysWhat({})), false, "an empty filter names nothing and is refused")
