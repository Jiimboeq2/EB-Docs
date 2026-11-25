-- Run a gather route
--
-- eco.harvest:runRoute(route) walks to each stop on the mesh, harvests every wanted node in reach, leaves the rest (it never clicks a node it leaves, and remembers it), and moves on. A named route comes from your config (cfg.harvest.routes).
--
-- kind:      snippet
-- expect:    Two stops: the ore and the wood are gathered, the blacklisted weed is never clicked and never looped on, and the route answers done.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.harvest, eb.economy
-- id:        harvest-route

-- offline stand-in: two route stops with nodes at each, and a walker that arrives on the next call
local CW = require("crafting.lib.craftworld")
local world = CW.world({ nodes = {
    { id = 1, name = "a fixture vein", tier = 2, category = "ore", near = "10,0,10" },
    { id = 2, name = "a fixture weed", tier = 1, category = "root", near = "10,0,10" },
    { id = 3, name = "a fixture log", tier = 2, category = "wood", near = "40,0,-5" } } })
local eco = CW.economy(world, { me = { level = 30 }, nav = CW.nav(world),
    cfg = { harvest = { blacklist = { ["a fixture weed"] = true },
        routes = { ["fixture loop"] = { { x = 10, y = 0, z = 10 }, { x = 40, y = 0, z = -5 } } } } } })

-- your script: a saved route by name, polled to the end
local status = CW.poll(function() return eco.harvest:runRoute("fixture loop") end)
local gathered, left = 0, 0
for _, node in ipairs(world.nodes) do
    if world.harvested[node.id] == "gathered" then gathered = gathered + 1 else left = left + 1 end
end
print(("route %s: %d gathered, %d left"):format(status, gathered, left))

-- check
DOCS.eq(status, "done", "the route finished")
DOCS.eq(gathered, 2, "ore and wood")
DOCS.eq(world.harvested[2], nil, "the weed was never clicked: the route leaves it and remembers it")
DOCS.eq(world.walked, 2, "one walk per stop")
