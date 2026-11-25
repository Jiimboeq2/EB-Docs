-- Take a work order, craft every step, hand it in
--
-- eco.writs:run{ count, kind } asks the Work Order Clipboard (or the rush-order giver) for an order, crafts what each step asks for, verifies a guessed recipe by watching the step move, and hands the order in.
--
-- kind:      snippet
-- expect:    One order with two steps is finished and handed in; the guessed spelling "a Fixture Spoon" is learned as Fixture Spoon for next time.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.writs, eb.economy
-- id:        writ-run

-- offline stand-in: a clipboard, a work bench, and the order it hands out
local CW = require("crafting.lib.craftworld")
local world = CW.world({ station = { name = "Work Bench" }, writGiver = { name = "Work Order Clipboard" },
    recipes = { { name = "Fixture Lantern", device = "Work Bench" }, { name = "Fixture Spoon", device = "Work Bench" } },
    nextWrit = { name = "a fixture work order", steps = {
        { text = "Create Fixture Lantern (0/2)", have = 0, need = 2, makes = "Fixture Lantern" },
        { text = "I need to create a Fixture Spoon", have = 0, need = 1, makes = "Fixture Spoon" } } } })
local eco = CW.economy(world)

-- your script
local status, why = CW.poll(function() return eco.writs:run({ count = 1, kind = "clipboard" }) end)
local learned = eco.env.cfg.writs.learned["a Fixture Spoon"]
print(("writs -> %s, %d handed in, learned: %s"):format(status, world.writsDone, tostring(learned)))

-- check
DOCS.eq(status, "done", "the run finished")
DOCS.eq(world.writsDone, 1, "one order handed in")
DOCS.eq(#world.made, 3, "two lanterns and a spoon")
DOCS.eq(learned, "Fixture Spoon", "the guess was verified and learned")
