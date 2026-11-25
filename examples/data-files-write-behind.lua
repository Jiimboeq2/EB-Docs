-- EB tested example: Save from game code without touching the disk in the frame
-- data-files-write-behind | snippet | topics: data, perf
--
-- What it does:  files.writeLater(path, text) only queues; a pulse job writes one file per slot, newest text wins.
-- Tested:        Ten quick saves of the same file coalesce into one write that lands on the next flush, with the last text.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
