-- Apply an adornment profile
--
-- eco.adornments:applyProfile(profile, opts) gets each missing adornment - from the bags, else the adornment depot in reach, else (opts.broker = true) the broker under opts.maxCopper - and applies it to the slot's worn piece. A slot with nothing worn is skipped.
--
-- kind:      snippet
-- expect:    The rune comes from the bags, the glyph from the adornment depot, both are applied; the feet are skipped because nothing is worn there.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.adornments, eb.economy
-- id:        adorn-apply-profile

-- offline stand-in: two worn pieces, one adornment in the bags, one in the adornment depot
local CW = require("crafting.lib.craftworld")
local world = CW.world({
    worn = { chest = { id = 50, name = "Fixture Vest" }, legs = { id = 51, name = "Fixture Greaves" } },
    bags = { { id = 9, name = "Fixture Rune" } },
    depots = { adorn = { { name = "Fixture Glyph", qty = 2 } } } })
local eco = CW.economy(world)

-- your script
local profile = { chest = "Fixture Rune", legs = "Fixture Glyph", feet = "Fixture Sigil" }
local status = CW.poll(function() return eco.adornments:applyProfile(profile, { name = "raid set" }) end)
local on = {}
for _, slot in ipairs({ "chest", "legs" }) do
    for _, ad in ipairs(world.worn[slot].adorns or {}) do on[#on + 1] = slot .. " " .. ad.name end
end
print("applied: " .. table.concat(on, ", "))

-- check
DOCS.eq(status, "done", "the profile run finished")
DOCS.eq(#on, 2, "two adornments applied")
DOCS.eq(world.depots.adorn[1].qty, 1, "the glyph came out of the adornment depot")
DOCS.check(CW.logged(world, "nothing worn in feet"), "the feet were skipped and said so")
