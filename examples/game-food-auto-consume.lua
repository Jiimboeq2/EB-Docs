-- EB tested example: Keep food and drink on auto-consume
-- game-food-auto-consume | snippet | topics: game, items, helpers
--
-- What it does:  ConsumableSlot("food") reads the worn food or drink slot; ToggleAutoConsume(slot) flips auto-consume. Turning it
--                on eats one at once when the effect is not on you.
-- Tested:        Auto-consume is off, the helper turns it on, and one loaf is eaten at once.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
