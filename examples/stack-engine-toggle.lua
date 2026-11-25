-- EB tested example: Switch a tag from the engine
-- stack-engine-toggle | snippet | topics: combat, fights
--
-- What it does:  engine:toggle switches a whole category (ae, mez, ho, dumbfires) or any custom tag; a custom tag also switches
--                the holder's tagged rows.
-- Tested:        toggle("burn", false) holds the tagged row, so the engine casts the next one; toggle("ae", false) skips the AE.
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
