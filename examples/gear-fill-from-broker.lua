-- EB tested example: Fill an empty slot from the broker
-- gear-fill-from-broker | snippet | topics: items
--
-- What it does:  eco.gearup:fillFromBroker{ slots, maxCopper } buys the best-scoring listing for each empty slot (the purchase
--                question answered only when it names that listing), then an auto-upgrade pass wears it.
-- Tested:        The legs slot is empty; the better of two listings is bought, the purchase is confirmed for that item, and the
--                leggings end up worn.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: nothing on the legs, two broker listings for that slot
local CW = require("crafting.lib.craftworld")
local world = CW.world({ listings = {
    { id = 1, name = "Fixture Leggings", slot = "legs", priceCopper = 500, stats = { wisdom = 20 } },
    { id = 2, name = "Fixture Cheap Pants", slot = "legs", priceCopper = 50, stats = { wisdom = 5 } } } })
local eco = CW.economy(world, { me = { subclass = "templar" } })

-- your script
local status = CW.poll(function() return eco.gearup:fillFromBroker({ slots = { "legs" }, maxCopper = 1000 }) end)
print("legs now: " .. (world.worn.legs and world.worn.legs.name or "nothing"))

-- check
DOCS.eq(status, "done", "bought and worn")
DOCS.eq(world.worn.legs.name, "Fixture Leggings", "the best-scoring listing")
DOCS.has(world.answers[1].prompt, "Fixture Leggings", "the purchase question named it")
DOCS.eq(world.answers[1].choice, 1, "and was answered Yes")
