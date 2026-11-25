-- EB tested example: TRUE or NULL, and numbers as text
-- tlo-exists-and-text | snippet | topics: tlos
--
-- What it does:  X(exists) answers TRUE or NULL - never FALSE - so test for "TRUE". Every answer is text: numbers come back as
--                "100" or "7.500000", booleans as TRUE / FALSE.
-- Tested:        With no popup (exists) reads NULL; with one it reads TRUE. A level and a flag come back as text.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()

-- your script
local none = IS.Parse("${ChoiceWindow(exists)}")
w.setWindow("choice", { text = "Join the fixture group?", choice1 = "Accept", choice2 = "Decline" })
local up = IS.Parse("${ChoiceWindow(exists)}")
local level, dead = IS.Parse("${Me.Level}"), IS.Parse("${Me.IsDead}")
print(('no popup: %s; popup: %s; level "%s"; dead "%s"'):format(none, up, level, dead))
local isUp = (up == "TRUE")                         -- the only safe test: anything else means "not there"

-- check
DOCS.eq(none, "NULL", "absent reads NULL, never FALSE")
DOCS.eq(isUp, true, "present reads TRUE")
DOCS.eq(type(level), "string", "numbers are text")
DOCS.eq(tonumber(level), 100, "convert with tonumber")
DOCS.eq(dead, "FALSE", "booleans are TRUE / FALSE text")
