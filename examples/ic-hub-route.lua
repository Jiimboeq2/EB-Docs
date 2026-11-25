-- EB tested example: A hub route the tank walks alone
-- ic-hub-route | snippet | topics: instances, nav
--
-- What it does:  hub.route lists the tank's own steps from the hub to the door: a walk, its own camp spot (who = "me"), a click
--                on a lever. A wait_group step loads but is skipped: the group holds in the hub and the door takes it in.
-- Tested:        The tank walks, camps itself, pulls the lever and uses the door; the wait_group step is skipped and said.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local INSTANCE = {
    schema = "eb.ic/1", zone = "Fixture Hollow", short = "fixture_hollow",
    hub = {
        zone = "fixture_docks", difficulty = "[Heroic I]",
        route = {                                             -- wins over hub.approach when both are given
            { id = "h1", act = "path", spots = { { 5, 0, 5 }, { 12, 0, 18 } } },
            { id = "h2", act = "campspot", name = "dock", spot = { 12, 0, 18 }, who = "me" },
            { id = "h3", act = "interact", actor = "a rusted fixture lever", verb = "pull" },
            { id = "h4", act = "wait_group" },
        },
        entrance = { loc = { 12, 0, 18 }, tolerance = 8 },
        door = { actor = "a fixture rift", verb = "enter" },
    },
    route = { { id = "inside", act = "wait", seconds = 1 } },
}

local env, world = require("instances.lib.icworld").make({ group = { { id = "is2", role = "healer" } } })
env.loadInstance = function() return INSTANCE end
local runner = require("eb.ic").new(env)
local inst = assert(runner:load("fixture_hollow"))
local ctx = runner:newCtx(inst, {})
local ok, why = runner:zoneIn(ctx)
for _, l in ipairs(world.lines) do if l:find("no wait for the group", 1, true) then print(l) end end

DOCS.check(ok, "in: " .. tostring(why))
DOCS.eq(world.did("walk"), 2, "the tank walked the hub route's two waypoints")
local _, camp = world.first("camp")
DOCS.eq(camp[3], "me", "the hub camp spot is the tank's own")
local _, lever = world.first("interact")
DOCS.eq(lever[2], "a rusted fixture lever", "the click on the way")
DOCS.eq(world.did("door"), 1, "then the door, once, for everyone")
