-- EB tested example: Ask about many abilities for the price of one read
-- game-readiness-one-read | snippet | topics: game, perf, combat
--
-- What it does:  Every ability you asked about recently is read in ONE batch at the first ask of a frame; the rest of the frame
--                answers from that batch. ReadyStats() shows it.
-- Tested:        Three readiness asks in a warm frame cost one game read; ReadyStats reports one read and two shared answers.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addAbility({ id = 5001, name = "Fixture Strike", ready = true })
w.addAbility({ id = 5002, name = "Fixture Ward", ready = false, secondsUntilReady = 9 })
w.addAbility({ id = 5003, name = "Fixture Mend", ready = true })
local names = { "Fixture Strike", "Fixture Ward", "Fixture Mend" }

-- your script
local game = require("eb.platform").game()
for _, n in ipairs(names) do game.AbilityReady(n) end      -- the first frame learns which names you use
game.BeginTick()                                             -- the next frame (EB's pulse does this every frame)
local before = game.GameDataReads()
local ready = {}
for _, n in ipairs(names) do ready[n] = game.AbilityReady(n) end
local reads = game.GameDataReads() - before
print(("%d asks, %d read"):format(#names, reads))

-- check
DOCS.eq(reads, 1, "one batched read for the whole set")
DOCS.eq(ready["Fixture Ward"], false, "the one on its timer")
local r, shared = game.ReadyStats()
DOCS.eq(r .. "/" .. shared, "1/2", "one read, two answers shared from it")
