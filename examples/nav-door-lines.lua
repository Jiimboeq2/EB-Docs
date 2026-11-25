-- EB tested example: Fix a door's verb on this PC
-- nav-door-lines | snippet | topics: nav, data
--
-- What it does:  A door line is "x y z verb name", tab separated. Write one with eb.nav_doors.line, merge a correction into a
--                door file's text, and keep a live fix on this PC's own layer with saveLocal - the shipped file is never touched.
-- Tested:        The first save adds the door, a second save at the same spot is already listed, a new verb is "fixed".
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: EB's nav data kept in memory (in game: the mesh store and this PC's own nav folder)
local w = DOCS.world()
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })

-- your script
local doors = require("eb.nav_doors")
local line = doors.line(12.5, 3, -4, "open", "a fixture hatch")
local parsed = doors.parse("# a comment\n" .. line .. "\nnot a door line\n")
local text, result = doors.merge(line .. "\n", "fixture_hollow", { x = 12.8, y = 3, z = -4, verb = "pull", name = "x" }, true)

local hatch = { x = 20, y = 0, z = 9, verb = "open", name = "a fixture hatch" }
local r1 = doors.saveLocal("fixture_hollow", hatch)                     -- a new door on this PC's layer
local r2 = doors.saveLocal("fixture_hollow", hatch)                     -- the same door again: nothing written
local r3 = doors.saveLocal("fixture_hollow", { x = 20.5, y = 0, z = 9, verb = "pull", name = "a fixture hatch" }, true)
print(("saveLocal: %s, %s, %s"):format(r1, r2, r3))
local now = doors.forZone("fixture_hollow")

-- check
DOCS.eq(line, "12.50\t3.00\t-4.00\topen\ta fixture hatch", "a door line is tab separated")
DOCS.eq(#parsed, 1, "comments and bad lines are skipped")
DOCS.eq(result, "fixed", "merging at the same spot with a new verb fixes it")
DOCS.has(text, "\tpull\t", "the merged text carries the new verb")
DOCS.eq(r1, "added", "added"); DOCS.eq(r2, "listed", "listed"); DOCS.eq(r3, "fixed", "fixed")
DOCS.eq(#now, 1, "one door for the zone")
DOCS.eq(now[1].verb, "pull", "with the corrected verb")
DOCS.eq(now[1].src, "local", "from this PC's own layer")
