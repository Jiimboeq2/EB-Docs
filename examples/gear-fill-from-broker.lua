-- Fill an empty slot from the broker
--
-- eco.gearup:fillFromBroker{ slots, maxCopper } buys the best-scoring listing for each empty slot (the purchase question answered only when it names that listing), then an auto-upgrade pass wears it.
--
-- kind:      snippet
-- expect:    The legs slot is empty; the better of two listings is bought, the purchase is confirmed for that item, and the leggings end up worn.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.gearup, eb.economy
-- id:        gear-fill-from-broker

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
