-- Read a skill value the way EB does
--
-- eb.economy.skills turns the game's skill text into cur / max, takes a temporary bonus off, works out the cap your levels allow, and names the state: notlearned, unreadable, level or done. Unknown is never 0.
--
-- kind:      snippet
-- expect:    The colour code is stripped (354/400, 18/560), junk does not parse, a +25 bonus comes off 57/425, the cap from levels 80 and 90 is 450, and each state comes out as the rules say.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.skills
-- id:        skill-parse-rules

-- your script (pure)
local Skills = require("eb.economy.skills")
local a = Skills.parse("\\#FFFFFF354/400")          -- the game's text: a colour code, then cur/max
local b = Skills.parse("\\#22FF2218/560")           -- 18/560, not 2218/560
local junk = Skills.parse("NULL")
print(("%d/%d and %d/%d"):format(a.cur, a.max, b.cur, b.max))

local boosted = Skills.withoutBonus({ ok = true, cur = 57, max = 425 }, 400)   -- a +25 buff raised both numbers
local cap = Skills.capFromLevels(80, 90)                                       -- 5 x the higher level
local states = {
    Skills.stateOf(false, { ok = true, cur = 0, max = 400 }),     -- reads 0 and nobody said it is learned
    Skills.stateOf(true, { ok = false }),                         -- learned, but the read failed
    Skills.stateOf(false, { ok = true, cur = 12, max = 400 }),
    Skills.stateOf(false, { ok = true, cur = 400, max = 400 }),
}
print("states: " .. table.concat(states, ", "))

-- check
DOCS.eq(a.cur + a.max, 754, "354/400")
DOCS.eq(b.cur, 18, "the colour code came off first")
DOCS.eq(junk.ok, false, "junk does not parse")
DOCS.eq(boosted.cur .. "/" .. boosted.max, "32/400", "the bonus came off both numbers")
DOCS.eq(cap, 450, "the cap from levels")
DOCS.eq(table.concat(states, ","), "notlearned,unreadable,level,done", "the four states")
