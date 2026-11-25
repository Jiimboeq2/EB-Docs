-- A route's plan helpers: skipped steps, repeats, stalls, rates
--
-- The route planner is pure: firstOnFrom skips the steps a route switched off, repeatsAt says whether a back-and-forth step goes round again at this level, stallCheck notices a run that stopped making progress, and perHour turns a count into an hourly rate.
--
-- kind:      snippet
-- expect:    Step 2 is the first one on; the repeat holds below its target level; a quiet run stalls after its limit.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.plroutes.plan
-- id:        plroute-plan-helpers

local plan = require("eb.plroutes.plan")

-- a route's steps, as normalize leaves them (offline: invented steps)
local route = { steps = {
    { name = "warm-up", off = true, levels = { 1, 10 } },
    { name = "fixture vale", levels = { 10, 20 }, again = 1, again_to = 18 },
    { name = "fixture hollow", levels = { 20, 30 } },
} }

-- your script
local first = plan.firstOnFrom(route, 1)
local again15 = plan.repeatsAt(route.steps[2], 15)
local again19 = plan.repeatsAt(route.steps[2], 19)
local clock, stalled = { seen = {} }, nil
plan.stallCheck(clock, 0, { kills = 12, xp = 40, zone = "Fixture Vale" }, 5)          -- the first look sets the clock
stalled = plan.stallCheck(clock, 301, { kills = 12, xp = 40, zone = "Fixture Vale" }, 5)
print(("30 kills in 20 minutes = %d per hour"):format(plan.perHour(30, 20)))

-- check
DOCS.eq(first, 2, "the switched-off warm-up is skipped")
DOCS.eq(again15, true, "the step repeats below level 18")
DOCS.eq(again19, false, "and not at 19")
DOCS.eq(stalled, true, "five quiet minutes is a stall")
DOCS.eq(plan.perHour(5, 0.5), 0, "under a minute gives no rate")
