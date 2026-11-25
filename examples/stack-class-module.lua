-- A class module of your own
--
-- Record a small class module - a heal template, a heal, a cure with its types, a rez, a stealth opener - into class facts, then build heal and cure rows that would otherwise be held.
--
-- kind:      snippet
-- expect:    The facts hold the template, the entries and the stealth openers; with them the heal, cure and rez rows build and run, and the class's own prefix names every entry.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.caststack.jsonstack_facts, eb.caststack.jsonstack
-- id:        stack-class-module

-- your script (pure Lua: no game needed)
local F = require("eb.caststack.jsonstack_facts")
local JS = require("eb.caststack.jsonstack")
local H = { New = function(Mx, prefix, o) return Mx end }          -- a class helper of your own: its New names the prefix
local unknown
local facts = F.record(function(M)                                  -- the class module: entries on four managers
    H.New(M, "FIXTURE", { forceNamedCA = false })
    M.Heals.DefineAbility({ name = "T_FixtureSingle", type = "SINGLE_BASIC", healWeight = 30 })   -- a heal template
    M.Heals.DefineAbility({ name = "FIXTURE_Mend", ability = "Fixture Mend", baseAbility = "T_FixtureSingle",
                            targets = "AllParty" })
    M.Heals.Enable("FIXTURE_Mend", { priority = 10 })
    M.Cures.DefineAbility({ name = "FIXTURE_Cleanse", ability = "Fixture Cleanse", type = "GROUP", tags = "CURE",
                            cureTypes = "noxious;arcane", targets = "AllParty" })
    M.Cures.Enable("FIXTURE_Cleanse")
    M.Cures.DefineAbility({ name = "FIXTURE_Revive", ability = "Fixture Revive", type = "GROUP_REZ", tags = "REZ",
                            targets = "AllParty" })
    M.Cures.Enable("FIXTURE_Revive")
    M.Dps.DefineAbility({ name = "FIXTURE_Strike", ability = "Fixture Strike", tags = "CA" })
    M.Dps.Disable("FIXTURE_Strike")
    M.Dps.SetStealthOpeners({ "Fixture Ambush" }, { "Fixture Sneak" })
    unknown = M.Dps.Enable("FIXTURE_Nothing")                       -- no such entry: false
end, { H = H })
print(("facts: prefix %s, %d entries, %d template"):format(facts.prefix, #facts.list, (function()
    local n = 0; for _ in pairs(facts.templates) do n = n + 1 end; return n end)()))

local mend = facts.byName.FIXTURE_Mend
local merged = F.effective(facts, mend)                             -- the fact with its template under it
local result = JS.build({ castStack = {
    { slot = 1, name = "Fixture Mend", ability = "Fixture Mend", type = "Heal", target = "@Group", cond = { ["%"] = 70 } },
    { slot = 2, name = "Fixture Cleanse", ability = "Fixture Cleanse", type = "Cure", target = "@Group", cond = {} },
    { slot = 3, name = "Fixture Revive", ability = "Fixture Revive", type = "Res", target = "@Group", cond = {} },
} }, { facts = facts })

-- check
DOCS.eq(facts.prefix, "FIXTURE", "the prefix the class helper's New was given")
DOCS.eq(facts.classOpts.forceNamedCA, false, "and its options")
DOCS.check(facts.templates.T_FixtureSingle ~= nil, "a T_ name with no ability is a template")
DOCS.eq(merged.healWeight, 30, "the heal inherits its template's weight")
DOCS.eq(F.group(facts, mend), "heal", "a Heals entry that is not kept up is a heal")
DOCS.eq(F.lineKey("Fixture Mend II"), "fixture mend", "facts and rows meet on the ability line")
DOCS.eq(facts.index.heal["fixture mend"][1], mend, "indexed by kind and line")
DOCS.eq(F.index(facts), facts, "index can be rebuilt after a change by hand")
DOCS.eq(facts.byName.FIXTURE_Strike.enabled, false, "Disable leaves an entry off")
DOCS.eq(facts.stealth.openers[1], "Fixture Ambush", "the stealth openers")
DOCS.eq(unknown, false, "Enable of a name never defined answers false")
DOCS.eq(#result.held, 0, "with the facts no row is held")
DOCS.eq(result.entries[1].group, "heal", "the heal row runs")
DOCS.eq(result.entries[2].gates.cureTypes, "noxious;arcane", "the cure took its types from the class")
DOCS.eq(result.entries[3].tags, "REZ", "the rez row runs")
