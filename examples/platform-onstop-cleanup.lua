-- Clean up when EB stops
--
-- pulse.onStop(name, fn) runs your cleanup when EB stops: release what you hold, save what you queued.
--
-- kind:      snippet
-- expect:    The cleanup runs once, with the reason EB stopped, and the job it cancels never runs again.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.platform
-- id:        platform-onstop-cleanup

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()

-- your script
local pulse = require("eb.platform").pulse()
local ticks, cleaned = 0, {}
pulse.every("docs.watcher", 250, function() ticks = ticks + 1 end)
pulse.onStop("docs.watcher", function(why)
    pulse.cancel("docs.watcher")
    cleaned[#cleaned + 1] = why
    print("cleanup: " .. tostring(why))
end)
w.runFor(1000)
w.stop()                                   -- (offline: EB stops; in game: eb stop, or the session ends)

-- check
DOCS.eq(#cleaned, 1, "the cleanup ran once")
DOCS.has(cleaned[1], "the example ended", "with the reason EB stopped")
DOCS.check(ticks >= 4, "the job ran while EB was up")
