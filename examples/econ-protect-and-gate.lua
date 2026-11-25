-- Protect an item from every bulk action
--
-- eco.inventory:protect(name) puts a name on the protect list; applyAction - the one door every sell, transmute, salvage, extract, destroy and deposit goes through - then refuses it with the reason. unprotect takes it off again (and remembers you did, so a default never comes back by itself).
--
-- kind:      snippet
-- expect:    The destroy is refused while the charm is protected and goes through after unprotect.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.inventory, eb.economy.rules
-- id:        econ-protect-and-gate

-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({ bags = { { name = "Fixture Charm", qty = 1 } } })
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me })

-- your script
local inv = eco.inventory
local charm = inv:scan()[1]
inv:protect("Fixture Charm")
local s1, why = inv:applyAction(charm, "destroy")
print("refused: " .. tostring(why))
DOCS.check(inv:isProtected(charm), "on the protect list")

inv:unprotect("Fixture Charm")
local s2 = inv:applyAction(charm, "destroy")
print("after unprotect: " .. s2)

-- check
DOCS.eq(s1, "blocked", "a protected item is never destroyed")
DOCS.eq(s2, "done", "unprotected, the destroy went through")
DOCS.eq(W.log[#W.log], "destroy Fixture Charm x1", "what the game was asked for")
DOCS.eq(inv:freeSlots(), 40, "the bags are empty again")
