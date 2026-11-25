-- A class set of adornments, picked for each character
--
-- Put class sets in the config (cfg.adorn.classSets, keyed by subclass, class or archetype). eco.adornments:classSetFor(me) picks the one for a character; applyClassSet() applies it.
--
-- kind:      snippet
-- expect:    The templar gets its own set, a warden falls back to the priest set, and applying the templar's set puts its rune on the chest.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.adornments, eb.economy
-- id:        adorn-class-set

-- offline stand-in: a templar with a vest on and the set's rune in the bags
local CW = require("crafting.lib.craftworld")
local world = CW.world({ worn = { chest = { id = 50, name = "Fixture Vest" } }, bags = { { id = 9, name = "Fixture Rune" } } })
local cfg = { adorn = { classSets = {
    templar = { chest = "Fixture Rune" },          -- a subclass's own set
    priest = { chest = "Fixture Ward" },           -- every other priest
} } }
local eco = CW.economy(world, { me = { name = "Fixturae", subclass = "templar" }, cfg = cfg })

-- your script
local mine = eco.adornments:classSetFor()                                  -- this character (the snapshot)
local warden = eco.adornments:classSetFor({ subclass = "warden" })         -- anyone else
print(("templar -> chest %s; warden -> chest %s"):format(mine.chest, warden.chest))
local status = CW.poll(function() return eco.adornments:applyClassSet() end)

-- check
DOCS.eq(mine.chest, "Fixture Rune", "the templar's own set")
DOCS.eq(warden.chest, "Fixture Ward", "the archetype's set for a warden")
DOCS.eq(status, "done", "the class set was applied")
DOCS.eq(world.worn.chest.adorns[1].name, "Fixture Rune", "on the chest")
