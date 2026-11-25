-- EB tested example: Turn a typed word into a zone
-- nav-zone-words | snippet | topics: nav, commands
--
-- What it does:  Match what a player types - initials, the start of a name, a word in it - against the zones EB knows. A word
--                that matches nothing answers nil, never a wrong zone; an ambiguous word lists its rivals so a script can ask.
-- Tested:        "fts" is the steppes by its initials, "hol" the hollow; "fixture" is ambiguous; "zzz" matches nothing.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS); in game the candidates are EB's own zone list
local w = DOCS.world()
local candidates = {
    { short = "fixture_steppes", display = "Fixture Thundering Steppes" },
    { short = "fixture_hollow", display = "Fixture Hollow" },
    { short = "fixture_port", display = "Fixture Port" },
}

-- your script
local zw = require("eb.nav_zoneword")
local steppes = zw.resolve("fts", candidates)                -- the initials of all three words
local hollow = zw.resolve("hol", candidates)                 -- the start of a word
local none, ranking = zw.resolve("fixture", candidates)      -- every zone has that word
local nothing = zw.resolve("zzz", candidates)
print(zw.explain("fts", candidates))
print(zw.explain("fixture", candidates))

-- check
DOCS.eq(steppes, "fixture_steppes", "initials pick the steppes")
DOCS.eq(hollow, "fixture_hollow", "the start of a word picks the hollow")
DOCS.eq(none, nil, "an ambiguous word picks nothing")
DOCS.check(ranking and ranking.ambiguous and #ranking.alternatives >= 1, "and names its rivals")
DOCS.eq(nothing, nil, "a word that matches nothing is nil, never a wrong zone")
