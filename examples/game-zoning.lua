-- EB tested example: Hold a helper while a zone loads
-- game-zoning | snippet | topics: game, nav, helpers
--
-- What it does:  Zoning() is true while a zone loads (and at character select); InGame() is false then. A helper that acts in the
--                world checks them first and waits.
-- Tested:        The helper skips its work while the zone loads and runs it once the new zone is in.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.world.zoning, w.world.inGame = true, false

-- your script
local game = require("eb.platform").game()
local function ready() return not game.Zoning() and game.InGame() end
local skipped = not ready()
-- the load finishes
w.world.zoning, w.world.inGame, w.self.zone = false, true, "a fixture vale"
game.BeginTick()                                  -- a new frame (EB's pulse does this every frame)
if ready() then print("in the new zone: " .. game.Me().zone) end

-- check
DOCS.eq(skipped, true, "nothing ran while the zone loaded")
DOCS.eq(ready(), true, "ready once the load is over")
