-- EB tested example: Step out to a safe spot and back
-- fight-safe-spot | snippet | topics: fights, nav
--
-- What it does:  On a cue, walk to the fight's safe spot over the mesh, wait out the mechanic, and walk back to where you fought.
-- Tested:        The task leaves its fighting spot, stands at the safe spot during the wait, and is back within 3 m afterwards.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { x = 4, y = 0, z = 2 } })
require("nav.lib.navworld").attach(w, { zone = "fixture_lair" })

-- your script
local nav, move = require("eb.nav"), require("eb.move")
local SAFE = { x = -18, y = 0, z = 12 }
local atSafe
local ok = w.task(function()
    local hx, hy, hz = move.pos()                          -- where we fight from
    if not nav.goPoint(SAFE.x, SAFE.y, SAFE.z) then return false end
    atSafe = { move.pos() }
    eb.delay(4000)                                         -- the mechanic's length
    local back = nav.goPoint(hx, hy, hz)
    if back then print("back to fighting") end
    return back
end)

-- check
DOCS.eq(ok, true, "out and back")
DOCS.check(math.sqrt((atSafe[1] - SAFE.x) ^ 2 + (atSafe[3] - SAFE.z) ^ 2) <= 2.5, "it stood at the safe spot")
DOCS.check(math.sqrt((w.self.x - 4) ^ 2 + (w.self.z - 2) ^ 2) <= 3, "and is back where it fought")
