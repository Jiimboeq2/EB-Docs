-- EB tested example: Read one member the game layer does not return
-- tlo-getvar-verified | snippet | topics: tlos, items
--
-- What it does:  game.GetVar(expr, default) reads any member EB has verified, typed (a number comes back as a number), and
--                counted in the per-frame read budget.
-- Tested:        Reads the free bag slots as a number and the group-leader flag as a boolean.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.world.bagsFree = 12
w.self.isGroupLeader = true

-- your script
local game = require("eb.platform").game()
local free = game.GetVar("Me.InventorySlotsFree", 0)            -- the default answers when it cannot be read
local leader = game.GetVar("Me.IsGroupLeader", false)
print(("%d bag slots free, group leader: %s"):format(free, tostring(leader)))
if free <= 3 then print("bags nearly full") end

-- check
DOCS.eq(free, 12, "a number, not text")
DOCS.eq(leader, true, "a boolean")
