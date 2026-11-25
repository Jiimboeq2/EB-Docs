-- What an adornment profile still needs
--
-- An adornment PROFILE is { <slot> = <adornment name> }. eco.adornments:audit(profile) answers which slots already wear theirs and which still need it - and whether the missing adornment is in your bags.
--
-- kind:      snippet
-- expect:    The chest already wears its rune; the legs' glyph is missing but in the bags; the feet's sigil is missing and nowhere to be had.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.adornments, eb.economy
-- id:        adorn-audit

-- offline stand-in: worn gear (one piece already adorned) and one adornment in the bags
local CW = require("crafting.lib.craftworld")
local world = CW.world({
    worn = { chest = { id = 50, name = "Fixture Vest", adorns = { { slot = "white", name = "Fixture Rune" } } },
             legs = { id = 51, name = "Fixture Greaves" } },
    bags = { { id = 9, name = "Fixture Glyph" } } })
local eco = CW.economy(world)

-- your script
local profile = { chest = "Fixture Rune", legs = "Fixture Glyph", feet = "Fixture Sigil" }
local missing, present = eco.adornments:audit(profile)
local lines = {}
for _, p in ipairs(present) do lines[#lines + 1] = p.slot .. ": present" end
for _, m in ipairs(missing) do lines[#lines + 1] = ("%s: missing (%s)"):format(m.slot, m.where) end
table.sort(lines)
print(table.concat(lines, "; "))

-- check
DOCS.eq(#present, 1, "the chest is done")
DOCS.eq(#missing, 2, "legs and feet still need theirs")
DOCS.eq(eco.adornments:hasAdorn(world.worn.chest, "Fixture Rune"), true, "hasAdorn reads the worn piece")
DOCS.eq(eco.adornments:adornInBags("Fixture Glyph").id, 9, "adornInBags finds the bag item")
