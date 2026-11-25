-- EB tested example: The verb registry's parsers and its refusals
-- quest-verb-helpers | snippet | topics: quests
--
-- What it does:  The helpers every verb's arguments go through: flags takes the -flag words out of a hail, splitFields keeps a
--                ${...} condition whole, isComment spots a note line. dispatch runs one parsed line through its verb and turns a
--                refused verb, or one nobody registered, into a final "blocked" with the reason - a pack is never guessed at.
-- Tested:        The hail's -peaceful flag is found, the wait's condition stays one field, and both an unknown and a refused verb
--                stop with a reason.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
