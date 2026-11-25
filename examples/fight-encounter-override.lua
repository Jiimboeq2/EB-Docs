-- Shape combat for one encounter
--
-- Name the encounter you are in, register an override that applies only to it - no AE near the boss, its big cast on the interrupt list - and clear it when the fight is over so the next pull is back to normal.
--
-- kind:      snippet
-- expect:    During the encounter the AE is held (disableAE switches the AE tag off) and the boss's Ashen Wail is interrupted; after the encounter is cleared the AE casts again.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.combat, eb.combat.overrides, game
-- id:        fight-encounter-override

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Cleave", "Fixture Strike", "Fixture Stun" })
FW.recastOnUse(w, 10)                                       -- the game shows each cast as taken: the ability goes on its reuse
local boss = FW.mob(w, { id = 300, name = "the Ashen Overseer", type = "NamedNPC" })
FW.target(w, 300)

-- your script
local game = require("eb.platform").game()
local stack = require("eb.caststack.jsonstack").holder({ entries = {
    { name = "Fixture Cleave", ability = "Fixture Cleave", group = "dps", tags = "AE", priority = 99, gates = {} },
    { name = "Fixture Strike", ability = "Fixture Strike", group = "dps", tags = "CA", priority = 90, gates = {} },
    { name = "Fixture Stun", ability = "Fixture Stun", group = "dps", tags = "STUN", priority = 10, gates = {} },
} })
local engine = require("eb.combat").new({ shim = game.combatShim(), stacks = stack })   -- in game: eb.app.combat.engine

engine:setEncounter("the Ashen Overseer")                   -- where you are and what you fight
engine:addOverride({ name = "overseer", priority = 10, match = { encounter = "the Ashen Overseer" },
                     directives = { disableAE = true, interruptList = { "Ashen Wail" } } })
local d1 = engine:step()
local why = engine:passesGate(stack.get("Fixture Cleave"), engine:snapshot(), engine:snapshot().target)
boss.castId, boss.castName = 88, "Ashen Wail"               -- offline: the boss starts its big cast
w.runFor(500)                                               -- a quick art goes out at most every half second
local d2 = engine:step()
boss.castId = 0

engine:setEncounter(nil)                                    -- the fight is over: back to normal
engine:removeOverride("overseer")
w.runFor(500)
local d3 = engine:step()
print(("encounter: %s, then %s"):format(d2.reason, d3.ability == "Fixture Cleave" and "the AE again" or "?"))

-- check
DOCS.eq(d1.ability, "Fixture Strike", "no AE during the encounter")
DOCS.eq(why, "Toggled", "the override switched the AE tag off")
DOCS.eq(d2.kind, "interrupt", "the listed cast is interrupted")
DOCS.eq(d2.ability, "Fixture Stun", "with the stun")
DOCS.eq(d3.ability, "Fixture Cleave", "after the encounter the AE casts again")
