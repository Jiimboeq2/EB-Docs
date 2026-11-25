-- EB tested example: Interrupt a listed cast
-- combat-interrupt-cast | snippet | topics: combat, fights
--
-- What it does:  Give the engine the spell names worth stopping; when your target starts one, the next step casts the stack's
--                interrupt art (tagged INTERRUPT) before anything else.
-- Tested:        While the brute casts nothing the engine nukes; once it starts Fixture Blast the engine sends the interrupt.
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
FW.book(w, { "Fixture Stun", "Fixture Strike" })
FW.recastOnUse(w, 10)                                   -- the game shows each cast as taken: the ability goes on its reuse
local brute = FW.mob(w, { id = 200, name = "a fixture brute" })
FW.target(w, 200)

-- your script
local game = require("eb.platform").game()
local engine = require("eb.combat").new({ shim = game.combatShim(), stacks = { entries = function() return {
    { name = "Fixture Stun",   ability = "Fixture Stun",   group = "dps", tags = "INTERRUPT", priority = 10, gates = {} },
    { name = "Fixture Strike", ability = "Fixture Strike", group = "dps", tags = "CA",        priority = 90, gates = {} },
} end } })
engine:setInterruptList({ "Fixture Blast" })            -- or engine:setInterruptAll(true)

local quiet = engine:step()
w.runFor(500)                                            -- a quick art goes out at most every half second
brute.castId, brute.castName = 4242, "Fixture Blast"     -- offline: the brute starts its cast
local name = game.TargetCasting()                        -- your target's cast bar
local d = engine:step()
print(("%s: %s (%s)"):format(d.kind, d.ability, d.reason))

-- check
DOCS.eq(quiet.ability, "Fixture Strike", "nothing to stop: the rotation runs")
DOCS.eq(name, "Fixture Blast", "the target's cast bar reads the spell")
DOCS.eq(d.kind, "interrupt", "a listed cast is interrupted first")
DOCS.eq(d.ability, "Fixture Stun", "with the interrupt-tagged art")
