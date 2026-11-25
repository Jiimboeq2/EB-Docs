-- Test a helper's saves without a disk
--
-- ebkit.files.memory is a files host over a table: give it to a helper's save function in a test and read back exactly what it wrote - including a failed write.
--
-- kind:      snippet
-- expect:    The save lands in the table, list and copy work on it, a forced failure is reported, and the platform's own host answers isDir and probeNative.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   ebkit.files, eb.platform
-- id:        platform-files-memory-host

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()

-- your script: a helper's save, written against any files host
local function save(fs, state)
    return fs.write("notes/helper.json", ('{"kills":%d}'):format(state.kills))
end

local F = require("ebkit.files")
local disk = {}
local mem = F.memory(disk)                 -- in game: require("eb.platform").files()
save(mem, { kills = 3 })
local names = mem.list("notes", "*.json")
mem.copy("notes/helper.json", "notes/helper.json.old")
mem.failNext = "disk full"
local ok, why = save(mem, { kills = 4 })
print(("saved %d file: notes/%s; backup made; a failed save says: %s"):format(#names, names[1], why))

-- check
DOCS.eq(disk["notes/helper.json"], '{"kills":3}', "the first save is on the table")
DOCS.check(mem.exists("notes/helper.json.old"), "copy made the backup")
DOCS.eq(ok, false, "the forced failure is reported")
DOCS.eq(mem.writes, 1, "only the good save counted")
local fs = require("eb.platform").files()
DOCS.check(fs.isDir("notes") ~= true, "the real host has no such folder offline")
DOCS.eq(type(fs.probeNative()), "boolean", "probeNative answers true or false")
