-- List the items you can click
--
-- UsableItems() lists every usable item you wear or carry (bags and containers left out), with where it sits and how many; it keeps the list for 10 seconds.
--
-- kind:      snippet
-- expect:    Lists the worn blade and the tonic in the bags; the bag itself and the ore are left out.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-usable-items

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
