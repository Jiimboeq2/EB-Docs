-- Hand a built stack to category managers
--
-- jsonstack.apply defines every built entry on a set of category managers - damage, heals, cures, buffs - and item rows on an item manager, enabling all but the ones switched off.
--
-- kind:      snippet
-- expect:    Four entries are defined: the art and the buff enabled with their priorities, the row that is off in the profile defined but not enabled, and the item kept up on you.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.caststack.jsonstack
-- id:        stack-apply-managers

-- your script (pure Lua: no game needed)
local JS = require("eb.caststack.jsonstack")
local result = JS.build({ castStack = {
    { slot = 1, name = "Fixture Strike", ability = "Fixture Strike", type = "CA", cond = {} },
    { slot = 2, name = "Fixture Ward", ability = "Fixture Ward", type = "Buff", target = "@Me", cond = {} },
    { slot = 3, name = "Fixture Slow", ability = "Fixture Slow", type = "CA", disabled = true, cond = {} },
    { slot = 4, name = "Fixture Charm", ability = "Fixture Charm", type = "Buff", isItem = true, target = "@Me", cond = {} },
} }, { class = "warden" })

local log = { Dps = {}, Buffs = {}, Heals = {}, Cures = {}, items = {}, enabled = {} }
local function manager(kind)                                     -- a category manager: define, then enable
    return { DefineAbility = function(def, disabled) log[kind][#log[kind] + 1] = def.name end,
             Enable = function(name, o) log.enabled[name] = o.priority end }
end
local managers = { Dps = manager("Dps"), Heals = manager("Heals"), Cures = manager("Cures"), Buffs = manager("Buffs") }
local itemclick = { ClearDefined = function() end, Define = function(item) log.items[#log.items + 1] = item end }
local n = JS.apply(result, managers, itemclick)
print(("defined %d: Dps %d, Buffs %d, items %d"):format(n, #log.Dps, #log.Buffs, #log.items))

-- check
DOCS.eq(n, 4, "four entries defined")
DOCS.eq(log.enabled.WARDEN_FixtureStrike, 99, "the art enabled with its priority")
DOCS.check(log.enabled.WARDEN_FixtureWard ~= nil, "the buff enabled")
DOCS.eq(log.enabled.WARDEN_FixtureSlow, nil, "the row that is off in the profile is not enabled")
DOCS.eq(log.items[1].item, "Fixture Charm", "the item row went to the item manager")
DOCS.eq(log.items[1].target, "self", "kept up on you")
