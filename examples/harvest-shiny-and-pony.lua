-- Track shinies and send the pack pony out
--
-- eco.harvest:trackShiny{ color } reports each NEW shiny once (with its spot, and one line to the crew); eco.harvest:packPony{ answers } summons the pack pony, hails it and answers its questions.
--
-- kind:      snippet
-- expect:    The silver shiny is reported on the first call only and the crew hears one line; the pony's three questions are answered with the chosen options.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.harvest, eb.economy
-- id:        harvest-shiny-and-pony

-- offline stand-in: one silver shiny nearby, and a crew relay that only records
local CW = require("crafting.lib.craftworld")
local world = CW.world({ nodes = { { id = 7, name = "a fixture glint", color = "silver", shiny = true,
    x = 12, y = 3, z = -40 } } })
local heard = {}
local eco = CW.economy(world, { relay = { send = function(scope, line) heard[#heard + 1] = scope .. ": " .. line end } })

-- your script: poll the tracker each tick; only new finds come back
local first = eco.harvest:trackShiny({ color = "silver" })
local again = eco.harvest:trackShiny({ color = "silver" })
for _, n in ipairs(first) do print(("new shiny: %s at %d,%d,%d"):format(n.name, n.x, n.y, n.z)) end

local pony = CW.poll(function() return eco.harvest:packPony({ answers = { 2, 1, 3 } }) end)
print("pack pony -> " .. pony)

-- check
DOCS.eq(#first, 1, "the shiny is reported")
DOCS.eq(#again, 0, "once")
DOCS.eq(#heard, 1, "the crew heard one line")
DOCS.eq(pony, "done", "the pony went out")
DOCS.eq(#world.answers, 3, "three questions answered")
DOCS.eq(world.answers[3].option, 3, "with the chosen options")
