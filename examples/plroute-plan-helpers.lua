-- EB tested example: A route's plan helpers: skipped steps, repeats, stalls, rates
-- plroute-plan-helpers | snippet | topics: tasks
--
-- What it does:  The route planner is pure: firstOnFrom skips the steps a route switched off, repeatsAt says whether a
--                back-and-forth step goes round again at this level, stallCheck notices a run that stopped making progress, and
--                perHour turns a count into an hourly rate.
-- Tested:        Step 2 is the first one on; the repeat holds below its target level; a quiet run stalls after its limit.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
