-- Add your own route step kind
--
-- runner.STEP holds the route step handlers by act and runner.ROUTE_ACTS the acts a route file may carry (a step with an act in neither is refused when the file loads). Add one entry to each and a route step with that act loads and runs: here a "ring_gong" step that clicks a gong and waits for the room's door to open. A handler returns ok, a note for the log, and false stops the run with the note as the reason.
--
-- kind:      snippet
-- expect:    The custom step runs between the built-in ones and the lap completes; a gong that is not there stops the run with the handler's reason.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.ic
-- id:        ic-custom-route-act

local IC = require("eb.ic")

-- your script: one entry in each table adds the act (they are shared by every runner: add it once, at start)
IC.ROUTE_ACTS.ring_gong = true                               -- the loader lets a route step with this act in ...
IC.STEP.ring_gong = function(runner, s, ctx)                  -- ... and this is what the runner does for it
    if not runner.combat.find(s.gong, { alive = true }) then return false, "no gong called " .. s.gong .. " here" end
    if ctx.opts.dry then return true, "would ring " .. s.gong end
    runner.nav.interact(s.gong, "ring")
    runner.sleep(1500)                                        -- every wait goes through the env's sleep
    return true, "rang " .. s.gong .. ", the door opened"
end

local function instance(gong)
    return {
        schema = "eb.ic/1", zone = "Fixture Hollow", short = "fixture_hollow",
        hub = { zone = "fixture_docks", entrance = { loc = { 0, 0, 0 }, tolerance = 8 },
                door = { actor = "a fixture rift", verb = "enter" } },
        route = {
            { id = "gong", act = "ring_gong", gong = gong },
            { id = "walk", act = "path", spots = { { 0, 0, 12 } } },
        },
    }
end

-- offline stand-in for the game
local ICW = require("instances.lib.icworld")
local env, world = ICW.make({ start = "copy", alive = { ["a fixture gong"] = 100 } })
env.loadInstance = function() return instance("a fixture gong") end
local runner = IC.new(env)
local ok, why = runner:run(assert(runner:load("fixture_hollow")))
for _, l in ipairs(world.lines) do if l:find("ring_gong", 1, true) then print((l:gsub("^%[ic%] ", ""))) end end

local env2 = ICW.make({ start = "copy" })
env2.loadInstance = function() return instance("a missing gong") end
local runner2 = IC.new(env2)
local ok2, why2 = runner2:run(assert(runner2:load("fixture_hollow")))
print("stopped: " .. tostring(why2))

-- check
DOCS.check(ok, "the lap with the custom step completes: " .. tostring(why))
DOCS.eq(world.did("interact"), 1, "the gong was rung once")
DOCS.eq(ok2, false, "a handler's false stops the run")
DOCS.has(why2, "no gong called a missing gong here", "with the handler's own reason")
IC.STEP.ring_gong = nil
IC.ROUTE_ACTS.ring_gong = nil
