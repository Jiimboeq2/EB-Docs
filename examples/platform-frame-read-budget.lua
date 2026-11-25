-- EB tested example: Stay inside the read budget
-- platform-frame-read-budget | snippet | topics: perf, game
--
-- What it does:  About 8 game reads a frame: Me, Target and Group come in a few batched reads; asking again is free.
-- Tested:        One frame reading Me, Target and Group twice stays at or under 8 reads; the second round costs 0.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
