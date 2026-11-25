-- Ask the mesh directly
--
-- eb.navd is the mesh router under the walker: is this zone's mesh ready, one route, the nearest point on the mesh, the floor height, a straight line's clearance.
--
-- kind:      snippet
-- expect:    The mesh reports ready after it loads, a 24 m route has 3 corners, the nearest mesh point and the floor read 0, and a wall blocks the straight line.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.navd
-- id:        nav-mesh-queries

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { x = 0, y = 0, z = 0 } })
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow", loadFrames = 2, walls = { { 10, -2, 12, 2 } } })

-- your script
local navd = require("eb.navd")
local zone = require("eb.zone").shortName()

local ok, why = navd.ready(zone)                  -- a zone's mesh loads in the background: "loading" first
print(("ready: %s (%s)"):format(tostring(ok), tostring(why)))
while not navd.ready(zone) do w.frame(1) end      -- in a task you would wait with eb.delay(100) instead
print("ready after loading: true")

local route = navd.path(0, 0, 0, 0, 0, 24)        -- ONE route: { {x,y,z,kind}, ..., why, partial }
local nx, ny, nz = navd.nearest(5, 3, 5)          -- the closest point on the mesh
local floor = navd.height(5, 0, 5)                -- the floor under a point
local clear = navd.clear(0, 0, 0, 20, 0, 0)       -- can the straight line be walked?
print(("route %d corners; nearest %.0f,%.0f,%.0f; floor %.0f; clear to 20,0,0: %s"):format(
    #route, nx, ny, nz, floor, tostring(clear)))

-- check
DOCS.eq(ok, false, "not ready while loading")
DOCS.eq(why, "loading", "says it is loading")
DOCS.eq(#route, 3, "a corner every 8 m")
DOCS.eq(route.partial, false, "a whole route")
DOCS.eq(ny, 0, "the nearest point is on the floor")
DOCS.eq(floor, 0, "the floor height")
DOCS.eq(clear, false, "the wall at x 10..12 blocks the straight line")
DOCS.eq(navd.meshWord(), ".nav", "EB's own mesh files")
