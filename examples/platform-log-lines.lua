-- EB tested example: Write a log line
-- platform-log-lines | snippet | topics: helpers
--
-- What it does:  P.log() writes tagged lines at four levels; a bad format string is printed as it is, never raised.
-- Tested:        Three lines reach the console, the last one carrying its unformatted text.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()

-- your script
local log = require("eb.platform").log()
log.info("buffwatch", "%d buffs up, %s missing", 7, "none")
log.warn("buffwatch", "power at %d%%", 12)
log.error("buffwatch", "%d of %d", "seven")      -- a wrong argument: the raw format is written, nothing raises
local n = 0
for _ in w.echoed():gmatch("buffwatch") do n = n + 1 end
print(("%d log lines"):format(n))

-- check
DOCS.check(w.said("[info] buffwatch 7 buffs up, none missing"), "info line formatted")
DOCS.check(w.said("[warn] buffwatch power at 12%"), "warn line formatted")
DOCS.check(w.said("[error] buffwatch %d of %d"), "a bad format prints the raw text")
DOCS.eq(n, 3, "three lines")
