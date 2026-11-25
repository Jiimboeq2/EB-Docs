-- EB tested example: A reload keeps your switches
-- stack-rebind-keeps-switches | snippet | topics: combat, fights
--
-- What it does:  rebind swaps a freshly built stack into the same holder and carries every row's on/off state across by name, so
--                a profile reload never undoes what a fight script switched.
-- Tested:        The row switched off before the reload is still off after it, and the holder is the same object the engine
--                holds.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local JS = require("eb.caststack.jsonstack")
local function build()                                  -- the profile as read again from its file
    return JS.build({ castStack = {
        { slot = 1, name = "Fixture Strike", ability = "Fixture Strike", type = "CA", disabled = false, cond = {} },
        { slot = 2, name = "Fixture Burn",   ability = "Fixture Burn",   type = "CA", disabled = false, cond = {} },
    } }, { class = "warden" })
end
local holder = JS.holder(build())
holder.setEntryEnabled("Fixture Burn", false)           -- a fight script switched it off
local same = holder.rebind(build())                     -- EB reloads the profile when its file changes
local burn
for _, e in ipairs(holder.entries()) do if e.ability == "Fixture Burn" then burn = e end end
print("after the reload: Fixture Burn " .. (burn.disabled and "off" or "on"))

-- check
DOCS.eq(burn.disabled, true, "the switch survived the reload")
DOCS.eq(same, holder, "rebind returns the same holder: never build a new one per tick")
DOCS.eq(#holder.entries(), 2, "the fresh entries are served")
