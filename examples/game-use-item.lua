-- Use an item when it is ready
--
-- HasItem(name) finds an item worn or in your bags, ItemReady(name) checks its timer, UseItem(name) clicks it.
--
-- kind:      snippet
-- expect:    Uses the ready potion and leaves the one still on its timer alone.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-use-item

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.world.items = {
    ["Fixture Tonic"] = { where = "bag", quantity = 4, ready = true, usable = true, id = 31 },
    ["Fixture Elixir"] = { where = "bag", quantity = 1, ready = false, usable = true, id = 32 },
}

-- your script
local game = require("eb.platform").game()
for _, name in ipairs({ "Fixture Tonic", "Fixture Elixir" }) do
    if game.HasItem(name) and game.ItemReady(name) then
        game.UseItem(name)
        print("used " .. name)
    end
end

-- check
local uses = {}
for _, a in ipairs(w.world.actions) do if a.kind == "useitem" then uses[#uses + 1] = a.name end end
DOCS.eq(#uses, 1, "one item used")
DOCS.eq(uses[1], "Fixture Tonic", "the ready one")
DOCS.eq(game.HasItem("Fixture Feather"), false, "an item you do not have")
