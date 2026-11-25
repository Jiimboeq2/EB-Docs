-- EB tested example: Check that the game extension is ready
-- tlo-isxeq2-ready | snippet | topics: tlos, helpers
--
-- What it does:  ${ISXEQ2.IsReady} is TRUE once ISXEQ2 can answer game reads; Extension[ISXEQ2](exists) only says it is loaded.
--                game.IsExtensionReady() checks both, and is the first thing a stand-alone script should wait for.
-- Tested:        Not ready while ISXEQ2 is still starting; ready once it is, and in the world.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
