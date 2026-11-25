-- Check that the game extension is ready
--
-- ${ISXEQ2.IsReady} is TRUE once ISXEQ2 can answer game reads; Extension[ISXEQ2](exists) only says it is loaded. game.IsExtensionReady() checks both, and is the first thing a stand-alone script should wait for.
--
-- kind:      snippet
-- expect:    Not ready while ISXEQ2 is still starting; ready once it is, and in the world.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        tlo-isxeq2-ready

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.world.isxeq2Ready = false

-- your script
local game = require("eb.platform").game()
local early = game.IsExtensionReady()
w.world.isxeq2Ready = true                         -- a moment later
game.BeginTick()
if game.IsExtensionReady() then
    print("ISXEQ2 ready, in the world: " .. IS.Parse("${Me.InGameWorld}"))
end

-- check
DOCS.eq(early, false, "not ready while it starts")
DOCS.eq(game.IsExtensionReady(), true, "ready")
DOCS.eq(IS.Parse("${Extension[ISXEQ2](exists)}"), "TRUE", "the extension is loaded")
