-- Wear the best gear in the bags (auto-upgrade)
--
-- eco.gearup:aup(opts) compares every bag piece with what is worn in its slot, equips each upgrade, carries the old piece's adornments over, and repeats (up to 5 passes) until a pass changes nothing.
--
-- kind:      snippet
-- expect:    The better vest is worn and keeps the old vest's rune; the worse hat stays in the bags.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.gearup, eb.economy
-- id:        gear-auto-upgrade

-- offline stand-in: worn gear (the old vest is adorned) and two bag pieces
local CW = require("crafting.lib.craftworld")
local world = CW.world({
    worn = { chest = { id = 60, name = "Fixture Plain Vest", slot = "chest", stats = { wisdom = 10 },
                       adorns = { { slot = "white", name = "Fixture Rune" } } },
             head = { id = 63, name = "Fixture Good Hat", slot = "head", stats = { wisdom = 5 } } },
    bags = { { id = 61, name = "Fixture Fine Vest", slot = "chest", stats = { wisdom = 30 } },
             { id = 62, name = "Fixture Junk Hat", slot = "head", stats = {} } } })
local eco = CW.economy(world, { me = { subclass = "templar" } })

-- your script
local status = CW.poll(function() return eco.gearup:aup() end)
local chest = world.worn.chest
print(("chest: %s (%s), head: %s"):format(chest.name, (chest.adorns and #chest.adorns > 0) and "rune kept" or "bare",
    world.worn.head.name))

-- check
DOCS.eq(status, "done", "the passes ended")
DOCS.eq(chest.name, "Fixture Fine Vest", "the upgrade is worn")
DOCS.eq(chest.adorns[1].name, "Fixture Rune", "with the old piece's adornment")
DOCS.eq(world.worn.head.name, "Fixture Good Hat", "a worse piece is not worn")
