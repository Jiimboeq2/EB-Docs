-- Read, write, copy and list your helper's files
--
-- Every files host has the same calls: read, write, exists, copy and list, each answering a reason on failure.
--
-- kind:      snippet
-- expect:    A write, a one-per-file backup copy and a pattern list all work; a missing file reads nil with the reason.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.platform
-- id:        data-files-list-and-copy

-- offline stand-in: the platform's files service over a disk in a table (in game: the real EB folder)
local w = DOCS.world()
local disk = require("data.lib.memdisk").install()

-- your script (a tool or a task: these calls touch the disk now - game code saves with writeLater instead)
local files = require("eb.platform").files()
files.write("helper/notes.txt", "first line\n")
files.copy("helper/notes.txt", "helper/notes.txt.bak")      -- one backup per file, overwritten each time
local names = files.list("helper", "notes*")
print(table.concat(names, ", "))
local missing, why = files.read("helper/none.txt")

-- check
DOCS.eq(files.read("helper/notes.txt"), "first line\n", "read back, byte for byte")
DOCS.check(files.exists("helper/notes.txt.bak"), "the copy exists")
DOCS.eq(#names, 2, "list matches the pattern")
DOCS.eq(missing, nil, "a missing file reads nil")
DOCS.has(why, "no such file", "and says why")
DOCS.eq(disk["helper/notes.txt"], "first line\n", "(offline: it landed on the table disk)")
