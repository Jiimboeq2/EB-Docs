-- EB tested example: List the items you can click
-- game-usable-items | snippet | topics: game, items, ui
--
-- What it does:  UsableItems() lists every usable item you wear or carry (bags and containers left out), with where it sits and
--                how many; it keeps the list for 10 seconds.
-- Tested:        Lists the worn blade and the tonic in the bags; the bag itself and the ore are left out.
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
    ["Fixture Blade"] = { where = "worn", slot = 1, usable = true, id = 61 },
    ["Fixture Tonic"] = { where = "bag", quantity = 4, usable = true, id = 62 },
    ["Fixture Pack"] = { where = "bag", isContainer = true, usable = true, id = 63 },
    ["Fixture Ore"] = { where = "bag", usable = false, id = 64 },
}

-- your script
local game = require("eb.platform").game()
local list = game.UsableItems()
table.sort(list, function(a, b) return a.name < b.name end)
local parts = {}
for _, it in ipairs(list) do
    parts[#parts + 1] = it.name .. ((it.qty or 1) > 1 and (" x" .. it.qty) or "") .. " (" .. it.where .. ")"
end
print("usable: " .. table.concat(parts, ", "))

-- check
DOCS.eq(#list, 2, "the blade and the tonic")
DOCS.eq(list[2].where, "bag", "the tonic is in the bags")
