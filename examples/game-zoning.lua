-- Hold a helper while a zone loads
--
-- Zoning() is true while a zone loads (and at character select); InGame() is false then. A helper that acts in the world checks them first and waits.
--
-- kind:      snippet
-- expect:    The helper skips its work while the zone loads and runs it once the new zone is in.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-zoning

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
