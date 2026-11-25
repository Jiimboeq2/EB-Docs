-- EB tested example: Pin marks the crew and the map share
-- nav-mark-shared | snippet | topics: nav, data
--
-- What it does:  Save named spots - private ones for yourself, shared marks for the map and runs - list them by zone, find the
--                nearest, rename and remove them. The marks file is this PC's own.
-- Tested:        Two shared marks and one private spot; the nearest mark to 0,0 is the well; a rename keeps the spot.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: EB's nav data kept in memory (in game: this PC's own marks file)
local w = DOCS.world()
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })

-- your script
local marks = require("eb.nav_marks")
marks.set({ name = "old well", zone = "fixture_hollow", x = 12, y = 0, z = 4, shared = true, note = "regroup here" })
marks.set({ name = "north gate", zone = "fixture_hollow", x = 80, y = 2, z = 90, shared = true })
marks.set({ name = "my stash", zone = "fixture_hollow", x = -5, y = 0, z = -5, shared = false })
local shared = marks.list({ zone = "fixture_hollow", shared = true })
local near, dist = marks.nearest("fixture_hollow", 0, 0, { shared = true })
local nearName = near.name                       -- keep the name: a rename changes the record itself
print(("nearest shared mark: %s (%.1f m)"):format(nearName, dist))
marks.rename("old well", "camp well")
local zone, x = marks.resolve("camp well")
marks.remove("my stash")

-- check
DOCS.eq(#shared, 2, "two shared marks in the zone")
DOCS.eq(nearName, "old well", "the nearest shared one")
DOCS.eq(zone, "fixture_hollow", "the renamed mark kept its zone")
DOCS.eq(x, 12, "and its spot")
DOCS.eq(marks.get("old well"), nil, "the old name is gone")
DOCS.eq(marks.count(), 2, "two left after the removal")
