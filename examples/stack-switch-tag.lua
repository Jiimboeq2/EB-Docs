-- EB tested example: Switch every row with a tag
-- stack-switch-tag | snippet | topics: combat, fights
--
-- What it does:  A row's custom Tag groups rows a fight switches together: setTagEnabled turns every row carrying it off or on in
--                one call.
-- Tested:        Both BURN rows go off together and come back together; the untagged row is never touched.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
