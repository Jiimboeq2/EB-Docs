-- Switch a tag from the engine
--
-- engine:toggle switches a whole category (ae, mez, ho, dumbfires) or any custom tag; a custom tag also switches the holder's tagged rows.
--
-- kind:      snippet
-- expect:    toggle("burn", false) holds the tagged row, so the engine casts the next one; toggle("ae", false) skips the AE.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.combat, eb.caststack.jsonstack_live
-- id:        stack-engine-toggle

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Cleave", "Fixture Burn", "Fixture Strike" })
FW.mob(w, { id = 200, name = "a fixture brute" })
FW.target(w, 200)

-- your script
local JS = require("eb.caststack.jsonstack")
local holder = JS.holder(JS.build({ castStack = {
    { slot = 1, name = "Fixture Burn",   ability = "Fixture Burn",   type = "CA", disabled = false, cond = { Tag = "BURN" } },
    { slot = 2, name = "Fixture Strike", ability = "Fixture Strike", type = "CA", disabled = false, cond = {} },
} }, { class = "warden" }))
local engine = require("eb.combat").new({ shim = require("eb.platform").game().combatShim(), stacks = holder })

engine:toggle("burn", false)
local d = engine:step()
print("burn off: " .. tostring(d.ability))
engine:toggle("burn", true)
engine:toggle("ae", false)                         -- every AE-tagged entry is skipped until toggled back

-- check
DOCS.eq(d.ability, "Fixture Strike", "the BURN row is held")
DOCS.eq(engine:tagEnabled("AE"), false, "AE off")
DOCS.eq(engine:tagEnabled("BURN"), true, "burn back on")
local burn
for _, e in ipairs(holder.entries()) do if e.ability == "Fixture Burn" then burn = e end end
DOCS.eq(burn.disabled, false, "the holder's row is on again too")
