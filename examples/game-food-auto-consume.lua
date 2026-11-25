-- Keep food and drink on auto-consume
--
-- ConsumableSlot("food") reads the worn food or drink slot; ToggleAutoConsume(slot) flips auto-consume. Turning it on eats one at once when the effect is not on you.
--
-- kind:      snippet
-- expect:    Auto-consume is off, the helper turns it on, and one loaf is eaten at once.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-food-auto-consume

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.world.consumables = { food = { name = "Fixture Loaf", quantity = 12, autoConsume = false } }

-- your script
local game = require("eb.platform").game()
local food = game.ConsumableSlot("food")
if food and not food.autoConsume then
    game.ToggleAutoConsume("food")
    print(("food: %s x%d, auto-consume off -> on"):format(food.name, food.quantity))
end

-- check
local now = game.ConsumableSlot("food")
DOCS.eq(now.autoConsume, true, "auto-consume is on")
DOCS.eq(now.quantity, 11, "turning it on ate one")
DOCS.eq(game.ConsumableSlot("drink"), nil, "an empty slot is nil")
