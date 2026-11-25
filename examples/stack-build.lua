-- Build a cast stack from its rows
--
-- eb.caststack.jsonstack turns a cast-stack profile's rows into the entries the combat engine runs: slot order becomes priority, a row's Type becomes its group and tag.
--
-- kind:      snippet
-- expect:    Four rows build four entries in slot order (priority 99, 98, 97, 96); the summary line counts them without naming anything.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.caststack.jsonstack
-- id:        stack-build

-- your script: a profile as the stack's rows (EB reads them from the character's imported profile file)
local JS = require("eb.caststack.jsonstack")
local profile = { castStack = {
    { slot = 1, name = "Fixture Strike", ability = "Fixture Strike", type = "CA",     disabled = false, cond = {} },
    { slot = 2, name = "Fixture Burn",   ability = "Fixture Burn",   type = "CA",     disabled = false, cond = { Tag = "BURN" } },
    { slot = 3, name = "Fixture Hex",    ability = "Fixture Hex",    type = "Debuff", disabled = false, cond = {} },
    { slot = 4, name = "Fixture Flare",  ability = "Fixture Flare",  type = "CA",     disabled = false, cond = { Tag = "BURN" } },
} }
local result = assert(JS.build(profile, { class = "warden" }))
print(JS.summary(result))
for _, e in ipairs(result.entries) do
    print(("  %-22s %-14s %-4s priority %d tags %s"):format(e.name, e.ability, e.group, e.priority, tostring(e.tags)))
end

-- check
DOCS.eq(#result.entries, 4, "one entry per row")
DOCS.eq(result.entries[1].priority, 99, "slot 1 = priority 99")
DOCS.eq(result.entries[4].priority, 96, "slot 4 = priority 96")
DOCS.eq(result.entries[3].tags, "DEBUFF", "a Debuff row is tagged DEBUFF")
DOCS.eq(result.entries[1].group, "dps", "a combat art runs in the dps group")
DOCS.has(JS.summary(result), "4 entries", "the summary counts")
