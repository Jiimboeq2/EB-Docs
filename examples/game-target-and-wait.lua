-- Target an actor and wait for it to take
--
-- TargetActor(id) sends the target; WaitTarget(id, seconds) confirms it took. A wait needs an EB task, so the whole step runs inside one.
--
-- kind:      snippet
-- expect:    The target changes to the chosen actor and WaitTarget confirms it inside the task.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game, eb.platform
-- id:        game-target-and-wait

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addActor({ id = 220, name = "a fixture boar", distance = 9 })

-- your script: waits only work inside an EB task (in game: pulse.spawn("my.helper", fn) - the same thing)
local game = require("eb.platform").game()
local took = w.task(function()
    game.TargetActor(220)
    return game.WaitTarget(220, 1.0)      -- seconds, polled each frame; false after the timeout
end)
if took then print("targeted " .. game.Target().name) end

-- check
DOCS.eq(took, true, "WaitTarget confirmed the target")
DOCS.eq(w.self.targetId, 220, "the game's target is the boar")
