-- Ask the mesh service directly
--
-- Load a zone's mesh in the background with eb.navd.ready, then ask it for one route, the nearest mesh point, a straight line's clearance and the floor height - each one request.
--
-- kind:      snippet
-- expect:    ready() answers "loading" until the mesh is in, then true; the route reaches the goal; the reports read back.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.navd
-- id:        nav-mesh-service

-- offline stand-in for the game: EB's own mesh extension answering over a toy flat floor (in game: the zone's mesh)
local w = DOCS.world({ me = { x = 0, y = 0, z = 0 } })
local fake = require("nav.lib.ebnav").attach(w, { zone = "fixture_hollow", loadFrames = 2 })

-- your script
local navd = require("eb.navd")
local frames = 0
local ok, why = navd.ready("fixture_hollow")             -- the first ask starts the load and answers at once
while not ok and frames < 20 do                            -- in a task you would eb.delay(0) between asks
    w.frame(1); frames = frames + 1
    ok, why = navd.ready("fixture_hollow")
end
print(("mesh ready after %d frames (%s)"):format(frames, tostring(navd.source())))

local route = navd.pathChained(0, 0, 0, 30, 0, 40, 1.0)   -- ONE request for the whole walk
local last = route[#route]
local mx, my, mz, off = navd.nearest(12, 5, 12)           -- snap a point onto the mesh
local clear = navd.clear(0, 0, 0, 10, 0, 0)               -- can the straight line be walked?
local floor = navd.height(3, 2, 3)
print(("route: %d corners to %.0f,%.0f; nearest floor y %.1f; straight line clear: %s"):format(
    #route, last.x, last.z, my, tostring(clear)))

-- check
DOCS.eq(ok, true, "the mesh came in (" .. tostring(why) .. ")")
DOCS.check(frames >= 1, "it loaded in the background, not in the first ask")
DOCS.near(last.x, 30, 0.05, "the route ends at the goal x"); DOCS.near(last.z, 40, 0.05, "and z")
DOCS.eq(route.partial, false, "a whole route")
DOCS.near(my, 0, 1e-6, "the nearest mesh point is on the floor")
DOCS.eq(clear, true, "the straight line is clear")
DOCS.near(floor, 0, 1e-6, "the floor height")
DOCS.eq(navd.lib(), true, "the mesh extension answers")
