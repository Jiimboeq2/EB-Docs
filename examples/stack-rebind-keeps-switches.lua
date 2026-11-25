-- A reload keeps your switches
--
-- rebind swaps a freshly built stack into the same holder and carries every row's on/off state across by name, so a profile reload never undoes what a fight script switched.
--
-- kind:      snippet
-- expect:    The row switched off before the reload is still off after it, and the holder is the same object the engine holds.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.caststack.jsonstack_live, eb.caststack.jsonstack
-- id:        stack-rebind-keeps-switches

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
