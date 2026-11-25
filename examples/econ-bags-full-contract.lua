-- EB tested example: The economy's bags-full check
-- econ-bags-full-contract | snippet | topics: items, helpers
--
-- What it does:  economy.new{ drive = ... }:contract() is the table EB's brain calls between goals. bagsFull(snap) compares the
--                free slots with your threshold (3 by default); with a world snapshot it reads no game at all.
-- Tested:        Two free slots is full, ten is not; the free-slot count comes from the game.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
