-- EB tested example: Refuse a station that does not serve the recipe
-- craft-wrong-station | snippet | topics: items
--
-- What it does:  Pass the recipe's device as opts.station and craftOne checks the station in reach first: a station that does not
--                serve it is refused with its name, before anything is selected.
-- Tested:        With only a festive work bench in reach, a Work Bench recipe is refused and nothing is crafted.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: the only station in reach is a decoration
local CW = require("crafting.lib.craftworld")
local world = CW.world({ station = { name = "A Festive Work Bench" },
    recipes = { { name = "Fixture Lantern", level = 20, device = "Work Bench" } } })
local eco = CW.economy(world)

-- your script
local status, why = CW.poll(function() return eco.craft:craftOne("Fixture Lantern", { station = "Work Bench" }) end)
print(status .. ": " .. tostring(why))

-- check
DOCS.eq(status, "blocked", "refused")
DOCS.has(why, "does not serve", "with the reason")
DOCS.eq(#world.made, 0, "nothing was crafted")
