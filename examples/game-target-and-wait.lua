-- EB tested example: Target an actor and wait for it to take
-- game-target-and-wait | snippet | topics: game, combat, helpers
--
-- What it does:  TargetActor(id) sends the target; WaitTarget(id, seconds) confirms it took. A wait needs an EB task, so the
--                whole step runs inside one.
-- Tested:        The target changes to the chosen actor and WaitTarget confirms it inside the task.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
