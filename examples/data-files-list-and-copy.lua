-- EB tested example: Read, write, copy and list your helper's files
-- data-files-list-and-copy | snippet | topics: data
--
-- What it does:  Every files host has the same calls: read, write, exists, copy and list, each answering a reason on failure.
-- Tested:        A write, a one-per-file backup copy and a pattern list all work; a missing file reads nil with the reason.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
