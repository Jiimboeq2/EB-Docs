-- Write cast-stack rows by hand
--
-- Build a stack from hand-written rows of several Types and conditions, and read what came of each row: its kind, tags and priority, the rows held with a reason, an unknown Type, an empty row skipped.
--
-- kind:      snippet
-- expect:    Damage, buff, upkeep, heal, cure and rez rows build and run (a heal or cure with no class facts is built from its own Target, % and #); a buff with a health gate carries that gate; the allow-tag row is built off; a row aimed at an alias the profile never defined is held with that reason; the unknown Type and the empty row are reported.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.caststack.jsonstack, eb.caststack.jsonstack_kinds
-- id:        stack-row-format

-- your script (pure Lua: no game needed)
local JS = require("eb.caststack.jsonstack")
local rows = {                                                    -- priority order: slot 1 first
    { slot = 1, name = "Fixture Strike", ability = "Fixture Strike", type = "CA", cond = { Tag = "BURN" } },
    { slot = 2, name = "Fixture Blast", ability = "Fixture Blast", type = "NamedCA", cond = { ["#"] = 2 } },
    { slot = 3, name = "Fixture Mend", ability = "Fixture Mend", type = "Heal", target = "@Group", cond = { ["%"] = 70 } },
    { slot = 4, name = "Fixture Cleanse", ability = "Fixture Cleanse", type = "Cure", target = "@Group", cond = {} },
    { slot = 5, name = "Fixture Revive", ability = "Fixture Revive", type = "Res", target = "@Group", cond = {} },
    { slot = 6, name = "Fixture Ward", ability = "Fixture Ward", type = "Buff", target = "@Me", cond = {} },
    { slot = 7, name = "Fixture Quick", ability = "Fixture Quick", type = "CA", cond = { ["Aggro>"] = 80, ATag = "OPEN" } },
    { slot = 8, name = "Fixture Odd", ability = "Fixture Odd", type = "Buff", cond = { ["HP<"] = 50 } },
    { slot = 9, name = "", type = "CA", cond = {} },
    { slot = 10, name = "Fixture Mystery", ability = "Fixture Mystery", type = "Wobble", cond = {} },
    { slot = 11, name = "Fixture Regrowth", ability = "Fixture Regrowth", type = "Combat", target = "@Tank", cond = { ["RW<"] = 5 } },
    { slot = 12, name = "Fixture Shield", ability = "Fixture Shield", type = "Buff", target = "*offtank", cond = {} },
}
local result = JS.build({ castStack = rows }, { class = "warden" })
print(JS.summary(result))
local byAbility = {}
for _, e in ipairs(result.entries) do byAbility[e.ability] = e end
local heldWhy = {}
for _, h in ipairs(result.held) do heldWhy[h.name] = h.why end

-- check
DOCS.eq(#result.entries, 10, "ten rows became entries")
DOCS.eq(byAbility["Fixture Strike"].group, "dps", "a CA row is a damage entry")
DOCS.eq(byAbility["Fixture Strike"].priority, 99, "slot 1 = priority 99")
DOCS.eq(byAbility["Fixture Blast"].tags, "NAMED_CA", "a NamedCA row is tagged NAMED_CA")
DOCS.eq(byAbility["Fixture Ward"].group, "buff", "a Buff row")
DOCS.eq(byAbility["Fixture Regrowth"].target, "PartyTank", "@Tank becomes PartyTank")
DOCS.eq(byAbility["Fixture Quick"].disabled, true, "an allow-tag row is built off until its tag is raised")
DOCS.eq(byAbility["Fixture Quick"].allowTag, "OPEN", "carrying its allow tag")
DOCS.eq(byAbility["Fixture Mend"].group, "heal", "a heal row builds from its own Target, % and # when no class fact says more")
DOCS.eq(byAbility["Fixture Mend"].target, "AllParty", "aimed at the group")
DOCS.eq(byAbility["Fixture Cleanse"].tags, "CURE", "so does a cure row")
DOCS.eq(byAbility["Fixture Revive"].tags, "REZ", "and a Res row, tagged REZ")
DOCS.eq(byAbility["Fixture Odd"].def.useBelowMyHP, 50, "a buff's HP< is a gate on my own health")
DOCS.check(heldWhy["Fixture Mend"] == nil and heldWhy["Fixture Cleanse"] == nil and heldWhy["Fixture Odd"] == nil,
    "none of them is held")
DOCS.eq(heldWhy["Fixture Shield"], JS.ALIAS_UNDEFINED, "a * alias the profile's Aliases do not define is held: it names nobody")
DOCS.eq(result.unknown[1].name, "Fixture Mystery", "a Type EB does not run")
DOCS.eq(result.skipped[1].slot, 9, "an empty row is skipped")
DOCS.eq(JS.target("@Tank"), "PartyTank", "a row's target read the way build reads it")
DOCS.eq(JS.target("@Nowhere"), nil, "an @ word with no meaning cannot be aimed")
DOCS.eq(JS.bound(0), nil, "0 is an unset bound, never a gate at zero")
DOCS.eq(JS.bound("5"), 5, "a number is a bound")
DOCS.eq(JS.isToken("PartyTank"), true, "one of the engine's target words")
DOCS.eq(JS.isToken("Member1"), false, "a name is not")
DOCS.eq(JS.typeOf("namedca").group, "dps", "a Type, any case")
DOCS.check(#result.notes > 0, "notes say what is worth knowing")
