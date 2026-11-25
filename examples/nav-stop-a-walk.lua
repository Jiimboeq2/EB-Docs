-- Stop a walk cleanly
--
-- Start a long walk as a pulse task, then end it from outside with eb.nav.stop: the walk returns "stopped" and every key is released.
--
-- kind:      snippet
-- expect:    The walk is under way after a second, eb.nav.stop ends it, goPoint answers false, "stopped", and nothing is held.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.nav, eb.platform
-- id:        nav-stop-a-walk

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { x = 0, y = 0, z = 0 } })
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })

-- your script
local nav = require("eb.nav")
local move = require("eb.move")
local pulse = require("eb.platform").pulse()

local result
pulse.spawn("walk east", function()                 -- a task: the walk waits a frame at a time inside it
    result = { nav.goPoint(300, 0, 0) }
end)

w.runFor(1000)                                       -- a second of walking (offline: the docs world's clock)
local walking = nav.active ~= nil
local stopped = nav.stop("the example stops it")    -- safe any time; true when a walk was running
w.frame(3)
print(("the walk ended: %s %s"):format(tostring(result and result[1]), tostring(result and result[2])))

-- check
DOCS.check(walking, "a walk was under way")
DOCS.eq(stopped, true, "stop() says a walk was running")
DOCS.eq(result[1], false, "goPoint returned false")
DOCS.eq(result[2], "stopped", "...because it was stopped")
DOCS.check(w.self.x > 1 and w.self.x < 300, "it moved, and did not finish")
DOCS.check(not move.held("forward") and not move.held("turnLeft") and not move.held("turnRight"), "no key is held")
