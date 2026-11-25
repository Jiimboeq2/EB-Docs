-- Interrupt a listed cast
--
-- Give the engine the spell names worth stopping; when your target starts one, the next step casts the stack's interrupt art (tagged INTERRUPT) before anything else.
--
-- kind:      snippet
-- expect:    While the brute casts nothing the engine nukes; once it starts Fixture Blast the engine sends the interrupt.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.combat, game
-- id:        combat-interrupt-cast

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
