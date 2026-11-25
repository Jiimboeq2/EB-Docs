-- EB tested example: Use an item when it is ready
-- game-use-item | snippet | topics: game, items, helpers
--
-- What it does:  HasItem(name) finds an item worn or in your bags, ItemReady(name) checks its timer, UseItem(name) clicks it.
-- Tested:        Uses the ready potion and leaves the one still on its timer alone.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
