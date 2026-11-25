-- Read one member the game layer does not return
--
-- game.GetVar(expr, default) reads any member EB has verified, typed (a number comes back as a number), and counted in the per-frame read budget.
--
-- kind:      snippet
-- expect:    Reads the free bag slots as a number and the group-leader flag as a boolean.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        tlo-getvar-verified

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
