-- EB tested example: Repair at a mender and close the window
-- game-repair-and-close | snippet | topics: game, items, helpers
--
-- What it does:  Double-click the mender with ClickActor(id), then RepairAll() repairs everything; CloseMerchantWindow() closes
--                the window it opened.
-- Tested:        The mender is clicked, the repair goes out, and the merchant window is closed.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addActor({ id = 300, name = "a fixture mender", type = "NPC", distance = 4, isMerchant = true })
w.world.onClick = function(a, host) if a.id == 300 then host.world.windows.merchant = { forSale = 0 } end end

-- your script
local game = require("eb.platform").game()
local mender = game.NearestActor('Type == "NPC" && IsMerchant', 10, "mender")
if mender then
    game.ClickActor(mender.id)                     -- opens the mender's window
    game.RepairAll()
    game.CloseMerchantWindow()
    print("repaired at " .. mender.name)
end

-- check
DOCS.eq(mender.id, 300, "the mender was found")
DOCS.eq(w.world.commands[#w.world.commands], "/mender_repair_all", "repair all went out")
DOCS.eq(w.world.windows.merchant, nil, "the window is closed")
