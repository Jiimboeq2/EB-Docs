-- EB tested example: Readiness costs one read a frame
-- combat-ready-one-read | snippet | topics: combat, perf
--
-- What it does:  The abilities you ask about are remembered as a hot set: on the next frame one batched read answers all of them,
--                and asking again in the same frame is free.
-- Tested:        Five readiness asks in one frame after warm-up cost one read between them; the other four answer from the
--                frame's cache.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
