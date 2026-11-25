-- Turn a typed word into a zone
--
-- Match what a player types - initials, the start of a name, a word in it - against the zones EB knows. A word that matches nothing answers nil, never a wrong zone; an ambiguous word lists its rivals so a script can ask.
--
-- kind:      snippet
-- expect:    "fts" is the steppes by its initials, "hol" the hollow; "fixture" is ambiguous; "zzz" matches nothing.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.nav_zoneword
-- id:        nav-zone-words

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
