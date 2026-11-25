-- EB tested example: Swim corners, the water's surface and no dive in a fight
-- nav-swim-surface | snippet | topics: nav, fights
--
-- What it does:  The swim corner decision is pure: climb toward a higher corner, dive toward a lower one - but never dive while a
--                fight is on. The mesh's liquid surface says whether you are under water. A goal under the surface that the mesh
--                has no route to is NOT swum to: the walk fails, saying the spot is in open water the mesh does not reach.
-- Tested:        A corner below is a dive; the same dive in a fight holds; you are under the surface; a goal under the water is
--                said to be in open water the mesh does not reach - and never swum to straight.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: EB's mesh extension over a toy lake whose surface stands 1 m over the floor east of x = 60
local w = DOCS.world({ me = { x = 70, y = -2, z = 0 } })
require("nav.lib.ebnav").attach(w, { zone = "fixture_hollow", lavaAt = 1e9 })
local navd = require("eb.navd")
navd.ready("fixture_hollow"); w.frame(1); navd.ready("fixture_hollow")

-- your script
local swim, swimout, nav = require("eb.nav_swim"), require("eb.nav_swimout"), require("eb.nav")
local corner = { px = 70, py = -2, pz = 0, wx = 80, wy = -12, wz = 0, surfaceY = 1 }
local calm = swim.want(corner)                                   -- no fight: dive toward the lower corner
corner.inCombat = true
local fight = swim.want(corner)                                  -- a fight on: hold at the surface
print("dive in a fight: " .. tostring(fight.reason))
nav.swimDeps = { surfaceY = function() return 1 end, swimming = true }    -- the reads, swapped for this example
local surface = swim.surfaceY(nav, 70, -2, 0)
local inWater = swim.swimming(nav, 70, -2, 0)
local openWater = swimout.inOpenWater(nav, 70, -2, 0, 78, -6, 4)     -- words only: it moves nothing
nav.swimDeps = nil

-- check
DOCS.eq(calm.dive, true, "a corner 10 m below is a dive")
DOCS.eq(calm.forward, true, "and the walk swims on toward it")
DOCS.eq(fight.hold, true, "the same dive holds while a fight is on")
DOCS.eq(surface, 1, "the water's surface is 1 m up")
DOCS.eq(inWater, true, "you are in the water")
DOCS.eq(openWater, true, "a goal under the water the mesh does not reach is said as such - never swum to straight")
