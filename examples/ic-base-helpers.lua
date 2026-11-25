-- The runner's small helpers in a custom action
--
-- eb.ic.ic_base carries what every part of the runner uses: a log line in the runner's own voice, the flat distance doors and exits are measured with, the short countdown text and how often a long wait reports. Use them in an fn = function(ctx) action so your step reads like the runner's own.
--
-- kind:      snippet
-- expect:    The custom action logs one runner line with the distance to the lever and the countdown text.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.ic.ic_base, eb.ic
-- id:        ic-base-helpers

local base = require("eb.ic.ic_base")

-- offline stand-in for the game
local env, world = require("instances.lib.icworld").make({ start = "copy" })
local runner = require("eb.ic").new(env)

-- your script: a custom action, the kind an encounter's phase can hold as { fn = function(ctx) ... end }
local function leverCheck(ctx)
    local x, _, z = runner.nav.here()
    local d = base.flat(x, z, 3, 4)                          -- the lever stands at x = 3, z = 4
    local left = 5400                                        -- seconds a reuse timer has left
    base.say(runner, "lever is %.1f m away (flat); reset in %s, said every %d s", d, base.short(left), base.every(left))
    return true
end
leverCheck(runner:newCtx({ zone = "Fixture Hollow", short = "fixture_hollow", route = {} }))
print(world.lines[#world.lines])

-- check
DOCS.near(base.flat(0, 0, 3, 4), 5, 1e-9, "flat distance ignores height")
DOCS.eq(base.short(45), "45s", "under a minute")
DOCS.eq(base.short(1620), "27m", "minutes")
DOCS.eq(base.every(300), 120, "a short wait reports every 2 minutes")
DOCS.has(world.lines[#world.lines], "[ic] lever is 5.0 m away", "the line went to the runner's log")
