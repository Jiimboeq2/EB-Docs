-- EB tested example: Read a zone's mesh corrections
-- nav-fixes-layer | snippet | topics: nav, data
--
-- What it does:  The corrections file lists, per zone, the bridges that join two pieces of the mesh, the circles no route crosses
--                and whether its lava is floor. Both layers merge (the shipped one and this PC's own); checkBridges says which
--                bridges really join two pieces.
-- Tested:        Two bridges, one circle, lava is floor; one bridge joins two pieces, the other ends on the same piece.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: EB's nav data kept in memory (in game: the mesh store's corrections and this PC's own)
local w = DOCS.world()
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })
local store = require("eb.nav_store")
store.writeJson(store.storePath(store.FIXES), { fixes = {
    { zone = "fixture_hollow", lava_is_floor = true,
      bridges = { { from = "10,0,0", to = "14,2,0", kind = "climb", two_way = false } },
      avoid = { { at = "50,0,50", r = 4, h = 3 } } },
} })
store.writeJson(store.localPath(store.LOCAL_FIXES), { fixes = {             -- installed on this PC
    { zone = "fixture_hollow", bridges = { { from = "30,0,0", to = "31,0,1", kind = "level", two_way = true } } },
} })

-- your script
local fixes = require("eb.nav_fixes")
local line = fixes.describe("fixture_hollow")
print(line)
local rec = fixes.forZone("fixture_hollow")
-- which separate piece of the mesh a point is on (in game: eb.navd.pieceAt); here x < 12 is piece 1, else piece 2
local function pieceAt(x) return x < 12 and 1 or 2 end
local verdicts = fixes.checkBridges("fixture_hollow", pieceAt)
for _, v in ipairs(verdicts) do print(("bridge %s at %d: %s"):format(v.bridge.kindName, v.bridge.from[1], v.verdict)) end

-- check
DOCS.eq(#rec.bridges, 2, "both layers merged: one shipped bridge, one installed")
DOCS.eq(fixes.lavaIsFloor("fixture_hollow"), true, "the zone's lava is floor")
DOCS.eq(#fixes.avoidCircles("fixture_hollow"), 1, "one circle no route crosses")
DOCS.eq(verdicts[1].verdict, "joins", "the climb joins two pieces")
DOCS.eq(verdicts[2].verdict, "same piece", "the installed bridge does nothing: both ends on one piece")
DOCS.eq(fixes.lavaIsFloor("fixture_vale"), false, "a zone with no corrections")
