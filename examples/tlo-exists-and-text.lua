-- TRUE or NULL, and numbers as text
--
-- X(exists) answers TRUE or NULL - never FALSE - so test for "TRUE". Every answer is text: numbers come back as "100" or "7.500000", booleans as TRUE / FALSE.
--
-- kind:      snippet
-- expect:    With no popup (exists) reads NULL; with one it reads TRUE. A level and a flag come back as text.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        tlo-exists-and-text

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
