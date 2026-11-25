-- EB tested example: One route step of each kind
-- ic-route-step-kinds | snippet | topics: instances
--
-- What it does:  A route mixes camp spots, walks, clicks, waits, a wait for an actor's death, loot, an announce and the exit. Run
--                one of each as the tank, then hand the same steps to a member's runner: it holds on every step that would move
--                it, because only the tank walks the route and the tank's camp spots move the group.
-- Tested:        The tank's lap runs every step in order and leaves by the exit; the member holds on path, campspot and interact.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local INSTANCE = {
    schema = "eb.ic/1", zone = "Fixture Hollow", short = "fixture_hollow",
    hub = { zone = "fixture_docks", entrance = { loc = { 0, 0, 0 }, tolerance = 8 },
            door = { actor = "a fixture rift", verb = "enter" } },
    route = {
        { id = "camp",     act = "campspot", name = "entry", spot = { 0, 0, -30 }, who = "group" },
        { id = "walk",     act = "path", spots = { { 0, 0, 10 }, { 12, 0, 20 } } },
        { id = "lever",    act = "interact", actor = "a rusty fixture lever", verb = "pull" },
        { id = "pause",    act = "wait", seconds = 2 },
        { id = "warden",   act = "wait_actor_dead", name = "a fixture warden", seconds = 30 },
        { id = "chest",    act = "loot", op = "chest" },
        { id = "said",     act = "announce", message = "chest: {{verdict.chest}}" },
        { id = "out.walk", act = "path", spots = { { 0, 0, -38 } } },
        { id = "out",      act = "zoneout", via = "exit" },
    },
}

-- offline stand-in for the game (in game EB hands the runner its live nav, combat engine and crew)
local ICW = require("instances.lib.icworld")
local env, world = ICW.make({ alive = { ["a fixture warden"] = 100 }, drops = { "a fixture chest" } })
env.loadInstance = function() return INSTANCE end

-- your script: the tank runs the lap
local IC = require("eb.ic")
local runner = IC.new(env)
local inst = assert(runner:load("fixture_hollow"))
local ok, why, report = runner:run(inst)
print("lap: " .. tostring(why))

-- a member's runner gets the same steps and holds (the step handlers can be called one at a time)
local menv = ICW.make({ tank = false, start = "copy" })
local member = IC.new(menv)
local mctx = member:newCtx(inst)
local _, onPath = member:stepPath(inst.route[2], mctx)
local _, onCamp = member:stepCampspot(inst.route[1], mctx)
local _, onClick = member:stepInteract(inst.route[3], mctx)
print("member on path: " .. onPath)

-- check
DOCS.check(ok, "the lap completes: " .. tostring(why))
DOCS.eq(report.verdicts.chest, "a fixture chest", "the loot step recorded its drop")
DOCS.eq(world.did("camp"), 1, "the camp spot was set for the group")
DOCS.eq(world.did("interact"), 1, "the tank pulled the lever")
DOCS.eq(world.zone, "fixture_docks", "out by the exit door")
DOCS.has(onCamp, "holding", "a member holds on a campspot step")
DOCS.has(onClick, "holding", "and on an interact step: the tank does the click")
DOCS.eq(menv.nav.zone(), "fixture_hollow", "the member's runner moved nobody")
