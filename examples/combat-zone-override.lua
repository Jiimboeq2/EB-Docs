-- Change combat for one zone
--
-- Register an override for a zone (no AE in the vault); it applies only while the context matches, and needs no change to the cast stack.
--
-- kind:      snippet
-- expect:    Inside the vault the override skips the AE (it is ready, and still not cast) and the single-target art is cast; outside it the AE goes out.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.combat
-- id:        combat-zone-override

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Cleave", "Fixture Strike" })
FW.recastOnUse(w, 10)                              -- the game shows each cast as taken: the ability goes on its reuse
FW.mob(w, { id = 200, name = "a fixture brute" })
FW.target(w, 200)

-- your script
local game = require("eb.platform").game()
local engine = require("eb.combat").new({ shim = game.combatShim(), stacks = { entries = function() return {
    { name = "Fixture Cleave", ability = "Fixture Cleave", group = "dps", tags = "AE", priority = 99, gates = {} },
    { name = "Fixture Strike", ability = "Fixture Strike", group = "dps", tags = "CA", priority = 97, gates = {} },
} end } })
engine:addOverride({ name = "vault - no AE", priority = 10, match = { zone = "fixture_vault" },
                     directives = { disableAE = true } })

engine:setContext({ zone = "fixture_vault" })       -- an instance script sets this when it zones in
local inside = engine:step()                        -- the AE is ready, and the override still leaves it out
local ov = engine:activeOverride()
w.runFor(500)                                       -- a quick art goes out at most every half second
engine:setContext({ zone = "" })                    -- and again when it zones out
local outside = engine:step()
print(("outside: %s; in the vault: %s (override: %s)"):format(outside.ability, inside.ability, ov and ov.name))

-- check
DOCS.eq(outside.ability, "Fixture Cleave", "no override outside the vault")
DOCS.eq(inside.ability, "Fixture Strike", "the AE is skipped in the vault")
DOCS.eq(ov and ov.name, "vault - no AE", "the override in force")
DOCS.eq(engine:resolveOverride({}).disableAE, nil, "out of the vault again: back to the defaults")
