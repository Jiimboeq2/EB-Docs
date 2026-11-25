-- EB tested example: What a walk costs
-- nav-perf-one-route | snippet | topics: nav, perf
--
-- What it does:  A walk plans ONE route up front and then only reads your position each frame: count the route requests and the
--                game reads per frame.
-- Tested:        A 50 m walk asks for one route, and no frame of it reads the game more than 8 times.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
