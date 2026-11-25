-- The verb registry's parsers and its refusals
--
-- The helpers every verb's arguments go through: flags takes the -flag words out of a hail, splitFields keeps a ${...} condition whole, isComment spots a note line. dispatch runs one parsed line through its verb and turns a refused verb, or one nobody registered, into a final "blocked" with the reason - a pack is never guessed at.
--
-- kind:      snippet
-- expect:    The hail's -peaceful flag is found, the wait's condition stays one field, and both an unknown and a refused verb stop with a reason.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.quest.verbs
-- id:        quest-verb-helpers

require("eb.quest")                                   -- loads every verb family into the registry
local verbs = require("eb.quest.verbs")

-- your script
local rest, found = verbs.flags("-peaceful,Warden Fixturo,1")
print(("hail args: %s (%s)"):format(rest, found.peaceful and "peaceful" or "-"))
local fields = verbs.splitFields('${If[${Me.X} < 400,TRUE,FALSE]},60')
local unknown, uwhy = verbs.dispatch({ cmd = verbs.parse("DanceWithFixtures 3") })
local refusedRow = verbs.refusedList()[1]
local ctx = { cmd = verbs.parse(refusedRow.verb .. " Fixture Vale") }
local refused, rwhy = verbs.dispatch(ctx)

-- check
DOCS.eq(rest, "Warden Fixturo,1", "the flag word is taken out")
DOCS.check(found.peaceful, "and reported")
DOCS.eq(#fields, 2, "the condition is one field, the seconds another")
DOCS.check(verbs.isComment("# a note in the pack"), "a # line is a comment")
DOCS.eq(unknown, "blocked", "a verb nobody registered stops the pack")
DOCS.has(uwhy, "not handled", "and says so")
DOCS.eq(refused, "blocked", "a refused verb stops the pack")
DOCS.check(ctx.final == true, "for good, not as a block to recover from")
DOCS.has(rwhy, refusedRow.why, "with the reason it is refused")
