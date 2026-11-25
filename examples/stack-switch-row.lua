-- Switch one cast-stack row off and on
--
-- The holder is the live cast stack the engine reads every step; setEntryEnabled switches a row by its name or ability, and the engine stops casting it at once.
--
-- kind:      snippet
-- expect:    With Fixture Strike switched off the engine casts Fixture Smash instead; switched back on, Fixture Strike again.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.caststack.jsonstack_live, eb.combat
-- id:        stack-switch-row

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Strike", "Fixture Smash" })
FW.recastOnUse(w, 10)                         -- the game shows each cast as taken: the ability goes on its reuse
FW.mob(w, { id = 200, name = "a fixture brute" })
FW.target(w, 200)

-- your script
local JS = require("eb.caststack.jsonstack")
local holder = JS.holder({ entries = {
    { name = "Fixture Strike", ability = "Fixture Strike", group = "dps", tags = "CA", priority = 99, gates = {} },
    { name = "Fixture Smash",  ability = "Fixture Smash",  group = "dps", tags = "CA", priority = 97, gates = {} },
} })
local engine = require("eb.combat").new({ shim = require("eb.platform").game().combatShim(), stacks = holder })

local ok, said = holder.setEntryEnabled("Fixture Strike", false)     -- on = true | false | nil (toggle)
print(said)
local off = engine:step()
w.runFor(500)                                                         -- a quick art goes out at most every half second
holder.setEntryEnabled("fixture strike", true)                        -- any case
local on = engine:step()

-- check
DOCS.eq(ok, true, "the row was found")
DOCS.eq(off.ability, "Fixture Smash", "switched off: the next row casts")
DOCS.eq(on.ability, "Fixture Strike", "switched on again: back to the top row")
DOCS.eq((holder.setEntryEnabled("Fixture Nothing", false)), false, "a name that is no row is refused")
