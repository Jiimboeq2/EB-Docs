-- EB tested example: Wait for something without freezing the game
-- game-wait-in-task | snippet | topics: game, perf, helpers
--
-- What it does:  Wait(seconds, cond) waits inside an EB task until cond() is true or the time runs out; the game keeps running
--                every frame meanwhile. WaitCasting(seconds) waits for your cast bar.
-- Tested:        The task waits until the cast starts (the frame after the world begins it), then reports it.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local frames = 0
w.world.onFrame = function(host)
    frames = frames + 1
    if frames == 2 then host.world.self.isCasting = true end          -- a cast starts two frames from now
end

-- your script: every wait lives inside a task (in game: require("eb.platform").pulse().spawn(name, fn))
local game = require("eb.platform").game()
local started = w.task(function()
    return game.WaitCasting(1.0)                   -- true as soon as the cast bar shows, false after 1 s
end)
print(("casting seen after %d frames"):format(frames))

-- check
DOCS.eq(started, true, "the cast was seen")
DOCS.check(frames >= 2 and frames < 10, "it waited a couple of frames, not the whole second")
