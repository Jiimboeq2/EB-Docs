-- EB tested example: Switch one cast-stack row off and on
-- stack-switch-row | snippet | topics: combat, fights
--
-- What it does:  The holder is the live cast stack the engine reads every step; setEntryEnabled switches a row by its name or
--                ability, and the engine stops casting it at once.
-- Tested:        With Fixture Strike switched off the engine casts Fixture Smash instead; switched back on, Fixture Strike again.
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
