-- Readiness costs one read a frame
--
-- The abilities you ask about are remembered as a hot set: on the next frame one batched read answers all of them, and asking again in the same frame is free.
--
-- kind:      snippet
-- expect:    Five readiness asks in one frame after warm-up cost one read between them; the other four answer from the frame's cache.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        combat-ready-one-read

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
local names = { "Fixture Art 1", "Fixture Art 2", "Fixture Art 3", "Fixture Art 4", "Fixture Art 5" }
FW.book(w, names)

-- your script
local game = require("eb.platform").game()
for _, n in ipairs(names) do game.AbilityReady(n) end    -- the first frame learns which abilities you care about
w.frame(1)
game.BeginTick()                                          -- a new frame (EB's pulse opens one every frame)
for _, n in ipairs(names) do game.AbilityReady(n) end
local reads, shared = game.ReadyStats()
print(("%d asks: %d read, %d from the frame's cache"):format(#names, reads, shared))

-- check
DOCS.eq(reads, 1, "one batched read for the whole hot set")
DOCS.eq(shared, 4, "the rest answer from this frame's cache")
