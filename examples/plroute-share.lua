-- Share a route: the scrub and the short code
--
-- eb.plroutes.share makes a route safe to hand to a friend: scrubForShare replaces a camp puller's character name with "me" (roles stay) and says what it removed; shortCode gives the same PL- code for the same plan every time, so two copies of a plan can be told apart from two different plans.
--
-- kind:      snippet
-- expect:    The puller's name is scrubbed to me, the code is stable, and changing one step changes the code.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.plroutes.share, eb.plroutes.route
-- id:        plroute-share

local Share = require("eb.plroutes.share")
local Route = require("eb.plroutes.route")

local route = {
    schema = "eb-plroute/1", name = "Fixture camp",
    steps = { { kind = "hunt", zone = "Fixture Vale", where = "camp", at = { x = 1, y = 0, z = 2 },
                goal = { kind = "level", value = 30 },
                pull = { mode = "camp", puller = "Fixturo", target_order = "closest" } } },
}
local clean, removed = Share.scrubForShare(route)
print("scrubbed: " .. removed[1])

local code1, code2 = Share.shortCode(route), Share.shortCode(route)
local other = Route.normalize(route)
other.steps[1].goal.value = 40
local code3 = Share.shortCode(other)

DOCS.eq(clean.steps[1].pull.puller, "me", "a character name never leaves in a share")
DOCS.eq(code1, code2, "the same plan, the same code")
DOCS.check(code1 ~= code3, "a different plan, a different code")
DOCS.check(Share.isShortCode(code1), "PL-XXXXXXX")
DOCS.eq(Route.check(Route.normalize(route)), "", "a complete camp step passes the route check")
