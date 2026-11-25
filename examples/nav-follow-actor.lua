-- Follow an actor
--
-- Follow a named actor over the mesh with eb.nav.follow; with once = true it returns as soon as you have caught up.
--
-- kind:      snippet
-- expect:    You end within the follow range (4 m) of the courier, and eb.actor.locOf found it by its exact name.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.nav, eb.actor
-- id:        nav-follow-actor

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { x = 0, y = 0, z = 0 } })
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })
w.addActor({ id = 501, name = "a fixture courier", type = "NPC", x = 24, y = 0, z = 18 })

-- your script
local nav = require("eb.nav")
local actor = require("eb.actor")

local x, y, z = actor.locOf("a fixture courier")    -- where it stands now (exact name, case-insensitive)
print(("the courier stands at %.0f, %.0f, %.0f"):format(x, y, z))

local ok, why = w.task(function()
    return nav.follow("a fixture courier", { once = true })   -- without once it keeps following until nav.stop()
end)
local gap = math.sqrt((w.self.x - x) ^ 2 + (w.self.z - z) ^ 2)
print(("caught up: %s, %.1f m away"):format(tostring(ok), gap))

-- check
DOCS.eq(ok, true, "follow caught up (" .. tostring(why) .. ")")
DOCS.check(gap <= nav.FOLLOW_RANGE + 1, "within the follow range")
DOCS.near(x, 24, 1e-6, "locOf read the actor's place")
