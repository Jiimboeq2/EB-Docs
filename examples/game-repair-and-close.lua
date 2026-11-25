-- Repair at a mender and close the window
--
-- Double-click the mender with ClickActor(id), then RepairAll() repairs everything; CloseMerchantWindow() closes the window it opened.
--
-- kind:      snippet
-- expect:    The mender is clicked, the repair goes out, and the merchant window is closed.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-repair-and-close

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
