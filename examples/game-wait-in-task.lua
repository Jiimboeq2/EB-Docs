-- Wait for something without freezing the game
--
-- Wait(seconds, cond) waits inside an EB task until cond() is true or the time runs out; the game keeps running every frame meanwhile. WaitCasting(seconds) waits for your cast bar.
--
-- kind:      snippet
-- expect:    The task waits until the cast starts (the frame after the world begins it), then reports it.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game, eb.platform
-- id:        game-wait-in-task

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
