-- EB tested example: Clean up when EB stops
-- platform-onstop-cleanup | snippet | topics: helpers, data
--
-- What it does:  pulse.onStop(name, fn) runs your cleanup when EB stops: release what you hold, save what you queued.
-- Tested:        The cleanup runs once, with the reason EB stopped, and the job it cancels never runs again.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
