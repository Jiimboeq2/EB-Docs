-- Refuse a station that does not serve the recipe
--
-- Pass the recipe's device as opts.station and craftOne checks the station in reach first: a station that does not serve it is refused with its name, before anything is selected.
--
-- kind:      snippet
-- expect:    With only a festive work bench in reach, a Work Bench recipe is refused and nothing is crafted.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.craft, eb.economy
-- id:        craft-wrong-station

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
