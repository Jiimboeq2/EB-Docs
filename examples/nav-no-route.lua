-- EB tested example: A walk the mesh has no route for fails and says why
-- nav-no-route | snippet | topics: nav, helpers
--
-- What it does:  EB moves a character only by walking a route on the zone's .nav mesh. A goal the mesh has no route to is not
--                walked to - no straight line, no fallback, no swim across open water: nav.goPoint answers false with the reason
--                in plain words, the character stays where it is, and whatever started the walk decides what to do next. The same
--                for a zone with no mesh at all - even a six metre step.
-- Tested:        A spot 60 m away when the mesh ends 20 m out answers false "no route on the .nav ... the mesh has no way to this
--                spot" and nothing moves; a spot the mesh reaches is walked to; a zone with no mesh answers false "no mesh: ..."
--                even for a 6 m step.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real): a mesh that ends 20 m from you
local w = DOCS.world({ me = { x = 0, y = 0, z = 0, heading = 0 } })
local mesh = require("nav.lib.navworld").attach(w, { zone = "fixture_hollow", reach = 20 })

-- your script
local nav, move = require("eb.nav"), require("eb.move")
local function walk(x, y, z) return w.task(function() return nav.goPoint(x, y, z) end) end

local okFar, whyFar = walk(0, 0, 60)                          -- 60 m out, the mesh ends 20 m out: no route
print("no route: " .. tostring(whyFar))
local x, y, z = move.pos()                                    -- still where it was: nothing was walked

local reached, whyNot = walk(10, 0, 10)                       -- 14 m: the mesh reaches it

mesh.ready = function() return false, "no .nav for fixture_hollow in EB's mesh store" end
local okNone, whyNone = walk(5, 0, 8)                         -- no mesh at all: even a short step fails
print("no mesh: " .. tostring(whyNone))

-- check
DOCS.eq(okFar, false, "a spot the mesh has no route to is not walked to")
DOCS.has(whyFar, "no route on the .nav", "and the answer says why")
DOCS.has(whyFar, "the mesh has no way to this spot", "in plain words")
DOCS.check(math.abs(x) < 1 and math.abs(z) < 1, "the character did not move: no straight run at a spot with no route")
DOCS.eq(reached, true, "a spot the mesh reaches is walked to (" .. tostring(whyNot) .. ")")
DOCS.eq(okNone, false, "with no mesh for the zone every walk fails, a 6 m step too")
DOCS.has(whyNone, "no mesh", "and says so")
DOCS.eq(nav.last.ok, false, "nav.last keeps how the walk ended")
DOCS.check(not move.held("forward"), "no key is held after a failed walk")
