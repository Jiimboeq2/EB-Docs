-- EB tested example: Where EB's nav data lives
-- nav-store-layout | snippet | topics: nav, data
--
-- What it does:  Two roots: the mesh store that ships with EB (read-only at run time) and this PC's own nav data. Point both at a
--                files host of your own - here one kept in memory - and read and write nav data through the one door.
-- Tested:        Paths join under each root; a JSON document written to the local root reads back as plain tables.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS); the files host here keeps everything in memory
local w = DOCS.world()

-- your script
local store = require("eb.nav_store")
store.configure({ root = "store", localRoot = "local", fs = require("ebkit.files").memory({}) })
local marksFile = store.localPath(store.MARKS)
local fixesFile = store.storePath(store.FIXES)
print("marks file: " .. marksFile)
local ok = store.writeJson(store.localPath(store.PLACES), { blacklist = { { zone = "fixture_hollow", x = 1, y = 0, z = 2, r = 6 } } })
local doc = store.readJson(store.localPath(store.PLACES))
local missing, why = store.readJson(store.storePath(store.SIDES))

-- check
DOCS.eq(fixesFile, "store\\fixes\\mesh_fixes.json", "a shipped file sits under the mesh store")
DOCS.eq(ok, true, "the JSON was written")
DOCS.eq(doc.blacklist[1].zone, "fixture_hollow", "and reads back as plain tables")
DOCS.eq(missing, nil, "a file that is not there answers nil")
DOCS.check(why ~= nil, "with a reason")
