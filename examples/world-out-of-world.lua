-- EB tested example: Do nothing while a zone loads
-- world-out-of-world | snippet | topics: helpers, game
--
-- What it does:  At character select or during a zone load the snapshot says inGame = false and carries nothing else to trust.
-- Tested:        A helper that checks snap.inGame skips its work while out of the world and resumes when the world is back.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
