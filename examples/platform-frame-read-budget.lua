-- Stay inside the read budget
--
-- About 8 game reads a frame: Me, Target and Group come in a few batched reads; asking again is free.
--
-- kind:      snippet
-- expect:    One frame reading Me, Target and Group twice stays at or under 8 reads; the second round costs 0.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game, eb.platform
-- id:        platform-frame-read-budget

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ pulse = false })
for i = 1, 5 do
    w.addMember({ name = "Mate" .. i, id = 10 + i, class = "templar", healthPct = 80, inZone = true })
    w.addActor({ id = 10 + i, name = "Mate" .. i, type = "PC", isNPC = false, distance = 6 })
end
w.addActor({ id = 200, name = "a moss crawler", distance = 9 })
w.self.targetId = 200

-- your script
local game = require("eb.platform").game()
game.BeginTick()                                 -- EB's pulse does this at the start of every frame
local r0 = game.GameDataReads()
local me, target, group = game.Me(), game.Target(), game.Group()
local firstRound = game.GameDataReads() - r0
local again = game.GameDataReads()
game.Me(); game.Target(); game.Group()           -- the same frame: answered from the frame's memo
local secondRound = game.GameDataReads() - again
print(("first round: %d reads, second round: %d reads"):format(firstRound, secondRound))

-- check
DOCS.check(firstRound >= 1 and firstRound <= 8, "the first round fits the budget")
DOCS.eq(secondRound, 0, "the same frame reads nothing twice")
DOCS.eq(#group, 5, "the whole group came from one batch")
DOCS.eq(target.name, "a moss crawler", "and the target from the self batch")
