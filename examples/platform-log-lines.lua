-- Write a log line
--
-- P.log() writes tagged lines at four levels; a bad format string is printed as it is, never raised.
--
-- kind:      snippet
-- expect:    Three lines reach the console, the last one carrying its unformatted text.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.platform
-- id:        platform-log-lines

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
