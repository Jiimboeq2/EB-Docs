-- Run a power-level route, step by step
--
-- A power-level route is a list of STEPS: travel, hunt, actions and instance. Bind the route runner to its adapters, load a route table, and call runner:step(run) once per tick; like the quest runner it answers working, step_done, need_combat, need_loot, need_travel, complete or blocked. Travel and walks are mounted on the mesh, pulls are closest first, and a route never mentors down.
--
-- kind:      snippet
-- expect:    The route travels mounted, hails the camp master, then hunts with closest-first pulls until level 12 and completes.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.plroutes
-- id:        plroute-run

local ROUTE = {
    schema = "eb-plroute/1", name = "Fixture warm-up", level_of = "lowest",
    breaks = { hp = 50, power = 30, resume = 90, dead = true },
    steps = {
        { kind = "travel", name = "To the vale", zone = "Fixture Vale" },
        { kind = "actions", name = "Check in", actions = {
            { kind = "go", at = { x = 10, y = 0, z = 12 } },
            { kind = "click", actor = "a fixture camp master", how = "hail" },
            { kind = "wait", secs = 5 } } },
        { kind = "hunt", name = "Hunt to 12", zone = "Fixture Vale", levels = { 10, 20 },
          goal = { kind = "level", value = 12 }, pull = { mode = "single", target_order = "closest" } },
    },
}

local PL = require("loops.lib.plworld")
local deps, world = PL.make({ zone = "Fixture Docks", level = 10 })

local routes = require("eb.plroutes")
local runner = routes.bind(deps)
-- a hand-written route is normalized first: every option gets its default, every step its full shape
local handle = assert(runner:load(require("eb.plroutes.route").normalize(ROUTE)))
local run = runner:start(handle, {})
local status = PL.drive(runner, run, deps, world, 100)       -- the brain's part (need_combat -> the fight, ...)
print(("route %s at level %d"):format(status, world.level))

DOCS.eq(handle.check, "", "the route needs nothing filled in")
DOCS.eq(status, "complete", "the route ran to its end")
DOCS.eq(world.level, 12, "the hunt's goal: level 12")
local travel
for _, c in ipairs(world.calls) do if c[1] == "travel" then travel = c end end
DOCS.eq(travel[3], true, "travel is mounted")
for _, c in ipairs(world.calls) do if c[1] == "engage" then DOCS.eq(c[2], "closest", "pulls are closest first") end end
DOCS.eq(world.did("hail"), 1, "the actions step hailed the camp master")
