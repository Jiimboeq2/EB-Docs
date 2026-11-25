-- EB tested example: Protect an item from every bulk action
-- econ-protect-and-gate | snippet | topics: items
--
-- What it does:  eco.inventory:protect(name) puts a name on the protect list; applyAction - the one door every sell, transmute,
--                salvage, extract, destroy and deposit goes through - then refuses it with the reason. unprotect takes it off
--                again (and remembers you did, so a default never comes back by itself).
-- Tested:        The destroy is refused while the charm is protected and goes through after unprotect.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
