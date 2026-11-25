-- EB tested example: Wait for a condition, with a timeout
-- platform-wait-until | snippet | topics: helpers, game
--
-- What it does:  Inside a task, pulse.waitUntil(pred, timeoutMs) checks pred every frame and gives up after the timeout.
-- Tested:        The first wait sees the target appear; the second one times out and says so.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addActor({ id = 201, name = "a cave bat", distance = 12 })
w.host:run("docs.offline-player", function()      -- offline: someone targets the bat 600 ms from now
    wait(0.6)
    w.self.targetId = 201
end)

-- your script
local P = require("eb.platform")
local pulse, game = P.pulse(), P.game()
local first, second, why = nil, nil, nil
local result = w.task(function()
    first = pulse.waitUntil(function() return game.Me().targetId == 201 end, 3000)
    second, why = pulse.waitUntil(function() return game.Me().isDead end, 500)
    return first and "targeted after a wait" or "no target"
end)
print(("%s; second wait: %s"):format(result, tostring(why)))

-- check
DOCS.eq(first, true, "the target appeared before the timeout")
DOCS.eq(second, false, "the second wait gave up")
DOCS.eq(why, "timeout", "and said why")
