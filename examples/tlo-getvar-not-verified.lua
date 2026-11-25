-- EB tested example: What GetVar does with a member that is not verified yet
-- tlo-getvar-not-verified | snippet | topics: tlos
--
-- What it does:  EB only sends members verified to work. GetVar on a member that is not verified yet sends nothing and answers
--                your default; GateSkipped() lists what was held back.
-- Tested:        The not-yet-verified member answers the default, nothing is sent to the game, and GateSkipped names it.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()

-- your script
local game = require("eb.platform").game()
local before = w.host.stats.getvar
local arch = game.GetVar("Me.Archetype", "unknown")              -- not verified yet: held back
print(("archetype: %s (held back, %d reads)"):format(arch, w.host.stats.getvar - before))
local held = table.concat(game.GateSkipped(), ", ")

-- check
DOCS.eq(arch, "unknown", "your default, never a guess")
DOCS.eq(w.host.stats.getvar - before, 0, "nothing reached the game")
DOCS.has(held, "Me.Archetype", "GateSkipped lists it")
DOCS.eq(game.Me().subclass, "warden", "the game layer's own reads still answer")
