-- Save from game code without touching the disk in the frame
--
-- files.writeLater(path, text) only queues; a pulse job writes one file per slot, newest text wins.
--
-- kind:      snippet
-- expect:    Ten quick saves of the same file coalesce into one write that lands on the next flush, with the last text.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.platform
-- id:        data-files-write-behind

-- offline stand-in: the platform's files service over a disk in a table, and the flush job EB's boot runs for you
local w = DOCS.world()
local disk = require("data.lib.memdisk").install()
local P = require("eb.platform")
P.pulse().every("files", 250, function() P.files().flush(1) end, { prio = 90 })

-- your script
local files = P.files()
for i = 1, 10 do
    files.writeLater("helper/kills.json", '{"kills":' .. i .. '}')     -- from a job or a handler: just a queue
end
local pendingBefore = files.pending()
w.runFor(600)                                                          -- a couple of flush slots go by
print(("%d write for %d saves"):format(files.stats.writes, 10))

-- check
DOCS.eq(pendingBefore, 1, "one queued file, not ten")
DOCS.eq(files.stats.coalesced, 9, "nine saves folded into the first")
DOCS.eq(files.stats.writes, 1, "one write")
DOCS.eq(disk["helper/kills.json"], '{"kills":10}', "the newest text won")
