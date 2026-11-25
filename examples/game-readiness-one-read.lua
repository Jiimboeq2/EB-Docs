-- Ask about many abilities for the price of one read
--
-- Every ability you asked about recently is read in ONE batch at the first ask of a frame; the rest of the frame answers from that batch. ReadyStats() shows it.
--
-- kind:      snippet
-- expect:    Three readiness asks in a warm frame cost one game read; ReadyStats reports one read and two shared answers.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-readiness-one-read

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
