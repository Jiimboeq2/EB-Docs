-- EB tested example: Stop a walk cleanly
-- nav-stop-a-walk | snippet | topics: nav, helpers
--
-- What it does:  Start a long walk as a pulse task, then end it from outside with eb.nav.stop: the walk returns "stopped" and
--                every key is released.
-- Tested:        The walk is under way after a second, eb.nav.stop ends it, goPoint answers false, "stopped", and nothing is
--                held.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
