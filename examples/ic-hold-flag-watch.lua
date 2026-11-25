-- EB tested example: Tell a stuck combat flag from a real fight
-- ic-hold-flag-watch | snippet | topics: instances, fights
--
-- What it does:  The game's in-combat flag can stay lit with nobody fighting. The combat hold's flag watch times that bare flag:
--                HOLD.observe counts how long it has held, and after HOLD.STUCK_MS it is called stuck so a run never waits on it
--                forever. A real fight between looks (HOLD.hated) starts the count over.
-- Tested:        The bare flag is stuck after five seconds; a real fight in between resets the count.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local HOLD = require("eb.ic.ic_hold").HOLD

-- your script: one look a second at "in combat, nobody hated, nobody near"
local f = HOLD.newFlag()
local held = 0
for t = 0, 5000, 1000 do held = HOLD.observe(f, t, true) end
print(HOLD.stuckLine(held))

local st = HOLD.newState()
HOLD.observe(st.flag, 0, true)
HOLD.observe(st.flag, 4000, true)
HOLD.hated(st)                                        -- the group was seen in a real fight between looks
local after = HOLD.observe(st.flag, 5000, true)

-- check
DOCS.eq(held, 5000, "the bare flag held five seconds")
DOCS.check(f.stuck, "and is called stuck")
DOCS.eq(after, 0, "a real fight in between starts the count over")
DOCS.eq(HOLD.observe(HOLD.newFlag(), 9000, false), 0, "a look that is not a bare flag counts nothing")
