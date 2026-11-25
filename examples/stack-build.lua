-- EB tested example: Build a cast stack from its rows
-- stack-build | snippet | topics: combat, data
--
-- What it does:  eb.caststack.jsonstack turns a cast-stack profile's rows into the entries the combat engine runs: slot order
--                becomes priority, a row's Type becomes its group and tag.
-- Tested:        Four rows build four entries in slot order (priority 99, 98, 97, 96); the summary line counts them without
--                naming anything.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
