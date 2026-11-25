-- When does a combat wait end?
--
-- The instance runner's combat wait decides with a small pure rule: a fight on the group or a straggler nobody fights HOLDS the wait; a clear, or a combat flag with nothing behind it for 5 seconds, lets it go. A lone in-combat flag never holds a run forever.
--
-- kind:      snippet
-- expect:    The four cases decide fight, straggler, clear and stuck; only the first two hold the wait.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.ic.ic_hold
-- id:        ic-combat-hold

local HOLD = require("eb.ic.ic_hold").HOLD

-- decide(inCombat, anyHated, nearby NPCs, ms the bare flag has held)
local fight = HOLD.decide(true, true, {}, 0)
local straggler = HOLD.decide(true, false, { { id = 41, name = "a hollow skitter", dist = 12, combatMode = true } }, 0)
local clear = HOLD.decide(false, false, {}, 0)
local stuck = HOLD.decide(true, false, {}, 6000)
local early = HOLD.decide(true, false, {}, 2000)          -- not 5 s yet: a pull may still be landing

print(("in combat, nobody hated, nothing near, 6 s -> %s"):format(stuck.hold))

DOCS.eq(fight.hold, "fight", "someone in the group is hated")
DOCS.eq(straggler.hold, "straggler", "an NPC in combat mode nobody fights")
DOCS.eq(straggler.straggler.name, "a hollow skitter", "the straggler handed to the combat engine")
DOCS.eq(clear.hold, "clear", "out of combat")
DOCS.eq(stuck.hold, "stuck", "a bare combat flag for 5 s or more")
DOCS.eq(early.hold, "fight", "under 5 s it still counts as a fight")
DOCS.check(HOLD.holds(fight.hold) and HOLD.holds(straggler.hold), "fight and straggler hold the wait")
DOCS.check(not HOLD.holds(clear.hold) and not HOLD.holds(stuck.hold), "clear and stuck let it go")
