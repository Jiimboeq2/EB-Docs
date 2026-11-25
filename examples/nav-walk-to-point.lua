-- EB tested example: Walk to a point over the mesh
-- nav-walk-to-point | snippet | topics: nav, helpers
--
-- What it does:  Walk to an x,y,z in this zone with eb.nav.goPoint inside a pulse task - a route on the zone's mesh, EB's one
--                mover - and check the arrival and how the walk ended. A spot the mesh has no route to fails instead, and says
--                why (nav-no-route).
-- Tested:        The walk arrives within 2 m of the point; nav.last says it ended well; every key is let go.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { x = 0, y = 0, z = 0, heading = 0 } })
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })

-- your script
local nav = require("eb.nav")
local move = require("eb.move")

-- a walk waits for the game a frame at a time, so it runs inside an EB pulse task (never in an event handler)
local ok, why = w.task(function()
    return nav.goPoint(30, 0, 40, { onStatus = function(s) print("  nav: " .. s) end })
end)

local x, y, z = move.pos()
local left = math.sqrt((x - 30) ^ 2 + (z - 40) ^ 2)
print(("arrived %s, %.1f m from the point"):format(tostring(ok), left))

-- check
DOCS.eq(ok, true, "the walk arrived (" .. tostring(why) .. ")")
DOCS.check(left <= 2.0, "within the 2 m arrival circle")
DOCS.eq(nav.last.ok, true, "nav.last keeps how the walk ended")
DOCS.eq(nav.active, nil, "no walk is running any more")
DOCS.check(not move.held("forward"), "the forward key is let go at the end")
