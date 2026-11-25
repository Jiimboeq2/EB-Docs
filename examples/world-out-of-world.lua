-- Do nothing while a zone loads
--
-- At character select or during a zone load the snapshot says inGame = false and carries nothing else to trust.
--
-- kind:      snippet
-- expect:    A helper that checks snap.inGame skips its work while out of the world and resumes when the world is back.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.world, game
-- id:        world-out-of-world

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ pulse = false })

-- your script
local game = require("eb.platform").game()
local world = require("eb.world").new({ game = game })
local skipped, worked = 0, 0
local function helperTick()
    world.beginTick()
    local snap = world.snapshot()
    if not snap.inGame then skipped = skipped + 1; return end    -- nothing else in snap is real right now
    worked = worked + 1
end

w.world.inGame = false                     -- (offline: a zone is loading)
helperTick()
w.world.inGame = true
w.frame(10)
helperTick()
print(("skipped %d, worked %d"):format(skipped, worked))

-- check
DOCS.eq(skipped, 1, "skipped while out of the world")
DOCS.eq(worked, 1, "worked once the world was back")
