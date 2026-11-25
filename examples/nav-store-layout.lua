-- Where EB's nav data lives
--
-- Two roots: the mesh store that ships with EB (read-only at run time) and this PC's own nav data. Point both at a files host of your own - here one kept in memory - and read and write nav data through the one door.
--
-- kind:      snippet
-- expect:    Paths join under each root; a JSON document written to the local root reads back as plain tables.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.nav_store
-- id:        nav-store-layout

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
