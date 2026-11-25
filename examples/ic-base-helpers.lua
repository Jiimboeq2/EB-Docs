-- EB tested example: The runner's small helpers in a custom action
-- ic-base-helpers | snippet | topics: instances, helpers
--
-- What it does:  eb.ic.ic_base carries what every part of the runner uses: a log line in the runner's own voice, the flat
--                distance doors and exits are measured with, the short countdown text and how often a long wait reports. Use them
--                in an fn = function(ctx) action so your step reads like the runner's own.
-- Tested:        The custom action logs one runner line with the distance to the lever and the countdown text.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
