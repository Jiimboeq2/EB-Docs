-- EB tested example: Plan a route without walking it
-- nav-plan-route | snippet | topics: nav
--
-- What it does:  Ask eb.nav.plan for the corridor to a point: its corners, its goal and the mesh it came from, with no key
--                pressed.
-- Tested:        A 40 m route comes back as 5 corners ending on the goal; nothing moved and one route was asked for.
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

-- your script
local nav = require("eb.nav")
local plan, why = nav.plan(0, 0, 40)          -- one route from where you stand; nothing walks
if not plan then error("no route: " .. tostring(why)) end
print(("%d corner(s) to %.0f,%.0f,%.0f on the %s mesh"):format(#plan.waypoints, plan.goal.x, plan.goal.y, plan.goal.z,
    plan.mesh))
for i, c in ipairs(plan.waypoints) do print(("  corner %d: %.1f, %.1f, %.1f"):format(i, c.x, c.y, c.z)) end

-- check
DOCS.eq(#plan.waypoints, 5, "a corner every 8 m on the offline floor")
DOCS.near(plan.goal.z, 40, 1e-6, "the route ends on the goal")
DOCS.eq(plan.partial, nil, "a whole route, not a partial one")
DOCS.eq(mesh.calls.route, 1, "one route request")
DOCS.eq(w.self.z, 0, "planning moves nothing")
