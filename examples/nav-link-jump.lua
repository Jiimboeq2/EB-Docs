-- EB tested example: Where the mesh joins two floors: one jump tap
-- nav-link-jump | snippet | topics: nav
--
-- What it does:  Some routes cross a gap the mesh itself bridges with a link: a take-off corner, then the landing. The walk goes
--                to the take-off, faces the landing, taps the jump key ONCE and walks on from the landing - the same goPoint, no
--                other mover. A drop needs no key at all. EB never flies: a link is a jump, a climb, a drop or a door, never a
--                flight.
-- Tested:        The walk over a jump link arrives; the jump key was pressed exactly once, near the take-off and facing the
--                landing; nav.onLink was told it was a jump.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the mesh is real): a mesh whose way east crosses
-- a gap at x 20..22 by a jump link - the take-off at x 19.5, the landing at x 25
local w = DOCS.world({ me = { x = 0, y = 0, z = 0, heading = 90 } })
local mesh = require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })
mesh.pathChained = function(fx, fy, fz, tx, ty, tz)
    local route
    if fx < 22 then
        route = { { x = 19.5, y = 0, z = 0, offmesh = true },       -- the take-off: a corner navd flags as a link
                  { x = 25, y = 0, z = 0, kind = 2 },               -- the landing; kind 1 drop, 2 jump, 3 door, 4 climb
                  { x = tx, y = ty, z = tz } }
    else
        route = { { x = tx, y = ty, z = tz } }
    end
    route.why, route.partial = "", false
    return route
end

-- your script
local nav, move = require("eb.nav"), require("eb.move")
local told, where = {}, nil
nav.onLink = function(kind, landing)                      -- told each time a jump or a climb key goes out
    told[#told + 1] = kind
    local x = move.pos()
    where = { x = x, off = math.abs(move.turnDelta(move.heading(), move.headingTo(landing.x, landing.z))) }
end
local ok, why = w.task(function() return nav.goPoint(40, 0, 0) end)

local taps = 0
for _, line in ipairs(w.host.log.exec) do if line == "press space" then taps = taps + 1 end end
print("jump key taps: " .. taps)
print("nav.onLink told: " .. table.concat(told, ", "))

-- check
DOCS.eq(ok, true, "the walk over the link arrives (" .. tostring(why) .. ")")
DOCS.near(w.self.x, 40, 2.5, "and ends on the goal")
DOCS.eq(taps, 1, "ONE tap of the jump key for the whole link")
DOCS.eq(told[1], "jump", "nav.onLink says what kind of link it was")
DOCS.check(where and where.x >= 18 and where.x <= 22, "the key went out at the take-off, not before it")
DOCS.check(where and where.off <= nav.FACE_TOL, "facing the landing")
DOCS.eq(nav.LINK_TAKEOFF, 1.5, "a take-off counts as reached within this many metres across")
DOCS.eq(nav.FLY, nil, "there is no flight mode to switch on: EB never flies")
