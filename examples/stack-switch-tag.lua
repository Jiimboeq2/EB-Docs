-- Switch every row with a tag
--
-- A row's custom Tag groups rows a fight switches together: setTagEnabled turns every row carrying it off or on in one call.
--
-- kind:      snippet
-- expect:    Both BURN rows go off together and come back together; the untagged row is never touched.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.caststack.jsonstack_live, eb.caststack.jsonstack
-- id:        stack-switch-tag

-- your script
local JS = require("eb.caststack.jsonstack")
local result = JS.build({ castStack = {
    { slot = 1, name = "Fixture Strike", ability = "Fixture Strike", type = "CA", disabled = false, cond = {} },
    { slot = 2, name = "Fixture Burn",   ability = "Fixture Burn",   type = "CA", disabled = false, cond = { Tag = "BURN" } },
    { slot = 3, name = "Fixture Flare",  ability = "Fixture Flare",  type = "CA", disabled = false, cond = { Tag = "BURN" } },
} }, { class = "warden" })
local holder = JS.holder(result)

local ok, said = holder.setTagEnabled("burn", false)    -- case-insensitive; a third argument true matches part of a tag
print(said)
local function state()
    local t = {}
    for _, e in ipairs(holder.entries()) do t[e.ability] = e.disabled and "off" or "on" end
    return t
end
local during = state()
holder.setTagEnabled("BURN", true)
local after = state()

-- check
DOCS.eq(ok, true, "rows carry the tag")
DOCS.eq(during["Fixture Burn"], "off", "tagged row 1 off")
DOCS.eq(during["Fixture Flare"], "off", "tagged row 2 off")
DOCS.eq(during["Fixture Strike"], "on", "the untagged row is untouched")
DOCS.eq(after["Fixture Burn"], "on", "back on together")
DOCS.eq((holder.setTagEnabled("NOPE", false)), false, "a tag no row carries is refused")
