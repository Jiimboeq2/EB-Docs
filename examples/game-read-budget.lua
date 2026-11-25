-- Stay inside the per-frame read budget
--
-- Me(), Target() and Group() together cost two game reads in a frame, however often they are asked; GameDataReads() counts this frame's reads so a helper can stay under about 8.
--
-- kind:      snippet
-- expect:    Asking for you, your target and your group five times each in one frame still costs two reads.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-read-budget

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addMember({ name = "Tankfixture", id = 11, class = "guardian", healthPct = 90, powerPct = 70, inZone = true })
w.addActor({ id = 11, name = "Tankfixture", type = "PC", isNPC = false, distance = 4 })
w.addActor({ id = 220, name = "a fixture boar", distance = 5 })
w.self.targetId = 220

-- your script
local game = require("eb.platform").game()
game.BeginTick()                                   -- a new frame (EB's pulse does this every frame)
local asks = 0
for _ = 1, 5 do
    game.Me(); game.Target(); game.Group()
    asks = asks + 3
end
local reads = game.GameDataReads()
print(("%d asks, %d reads this frame"):format(asks, reads))

-- check
DOCS.eq(reads, 2, "one read for you and your target, one for the group")
DOCS.check(reads <= 8, "well inside the budget")
