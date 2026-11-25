-- The economy's bags-full check
--
-- economy.new{ drive = ... }:contract() is the table EB's brain calls between goals. bagsFull(snap) compares the free slots with your threshold (3 by default); with a world snapshot it reads no game at all.
--
-- kind:      snippet
-- expect:    Two free slots is full, ten is not; the free-slot count comes from the game.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy, game
-- id:        econ-bags-full-contract

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.world.bagsFree = 2

-- your script: a tiny drive that answers the free slots from the game (EB's own drive does this in game)
local game = require("eb.platform").game()
local drive = { ["bags.slots"] = function() return game.GetVar("Me.InventorySlotsFree", 0), 40 end }
local eco = require("eb.economy").new({ drive = drive })
local c = eco:contract()
local full, free = c.bagsFull()
local fullTen = c.bagsFull({ bagsFreeSlots = 10 })              -- a world snapshot answers without a read
print(("%d free: %s; 10 free: %s"):format(free, full and "full" or "not full", fullTen and "full" or "not full"))

-- check
DOCS.eq(full, true, "2 free slots is full (threshold 3)")
DOCS.eq(fullTen, false, "10 free is not")
DOCS.eq((eco:validateContract()), true, "every function the brain calls is there")
