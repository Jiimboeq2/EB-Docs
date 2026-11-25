-- The pull and break rules behind a route
--
-- eb.plroutes.plan holds a route's decisions as pure functions: resolveCap turns "aggro by group" into a mob count, packDecide says whether a pack pull keeps walking or turns to fight, needBreak says when to rest or wait for a member, and goalMet says when a step is done.
--
-- kind:      snippet
-- expect:    A 3-box group caps a pack at 3, the pack turns at the cap, a member under 50% health calls a rest, and a level goal is met at its value.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.plroutes.plan
-- id:        plroute-plan-rules

local Plan = require("eb.plroutes.plan")

local cap = Plan.resolveCap("group", 1, 3)                              -- aggro_by group, 1 per member, 3 members
local keepWalking = Plan.packDecide(1, cap, 2, 25, false, false)        -- 1 mob on us, under the cap
local turn = Plan.packDecide(3, cap, 2, 25, false, false)               -- at the cap

local breaks = { hp = 50, power = 30, resume = 90, dead = true, range = 60, zone = true }
local members = { { name = "me", hp = 100, power = 100, dead = false, in_zone = true, dist = 0 },
                  { name = "Member1", hp = 40, power = 90, dead = false, in_zone = true, dist = 10 } }
local brk = Plan.needBreak(breaks, members, false)
print(brk.text)

local stepGoal = require("eb.plroutes.route").normalize({ steps = { { kind = "hunt", zone = "Fixture Vale",
    goal = { kind = "level", value = 30 } } } }).steps[1]

DOCS.eq(cap, 3, "one mob per group member")
DOCS.check(keepWalking ~= turn, "under the cap the pull goes on; at the cap it turns")
DOCS.eq(brk.kind, "rest", "a member under 50% health: rest")
DOCS.check(Plan.goalMet(stepGoal, { group_level = 30, my_level = 30, minutes = 0, kills = 0, runs = 0, aa = -1 }),
    "a level goal is met at its value")
DOCS.check(not Plan.goalMet(stepGoal, { group_level = 29, my_level = 29, minutes = 0, kills = 0, runs = 0, aa = -1 }),
    "and not before")
