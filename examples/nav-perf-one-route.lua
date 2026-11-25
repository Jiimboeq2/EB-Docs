-- What a walk costs
--
-- A walk plans ONE route up front and then only reads your position each frame: count the route requests and the game reads per frame.
--
-- kind:      snippet
-- expect:    A 50 m walk asks for one route, and no frame of it reads the game more than 8 times.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.nav, eb.move
-- id:        nav-perf-one-route

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { x = 0, y = 0, z = 0 } })
local mesh = require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })

-- your script: the walk; route planning happens once, never per frame
local nav = require("eb.nav")
local ok = w.task(function() return nav.goPoint(0, 0, 50) end)
w.frame(1)
print("routes asked: " .. mesh.calls.route)
print("most game reads in one frame: " .. w.host.stats.maxFrameReads)

-- check
DOCS.eq(ok, true, "arrived")
DOCS.eq(mesh.calls.route, 1, "one route for one walk on a clear floor")
DOCS.check(w.host.stats.maxFrameReads <= 8, "at most 8 game reads in any frame (the 100-FPS rule)")
