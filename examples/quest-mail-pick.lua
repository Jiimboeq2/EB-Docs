-- Pick a letter for OpenMail
--
-- The mail verbs pick a letter by its subject (and, when given, by the sender's whole name) at the nearest mailbox. The rules are pure: parseArgs reads the verb's arguments, shown takes the game's hidden key off a field, and pick finds the first letter that fits and counts how many do.
--
-- kind:      snippet
-- expect:    The second letter fits the subject; the take word is read; the hidden key is taken off.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.quest.verbs.mail
-- id:        quest-mail-pick

local mail = require("eb.quest.verbs.mail").mail       -- loading it registers the verbs; .mail holds the rules

-- the inbox rows, in the order the mailbox lists them (offline: invented letters)
local rows = { { subject = "Fixture Fair results" }, { subject = ":47541fd6e0da31d6:Your fixture lantern" },
               { subject = "Fixture Fair tickets" } }

-- your script: OpenMail "fixture lantern",take
local a = mail.parseArgs('"fixture lantern",take', false)
local index, fits = mail.pick(a, rows)
print(("letter %d of %d that fit"):format(index, fits))

-- check
DOCS.eq(a.subject, "fixture lantern", "the subject")
DOCS.eq(a.take, true, "the take word")
DOCS.eq(index, 2, "the letter that fits")
DOCS.eq(mail.shown(rows[2].subject), "Your fixture lantern", "the game's hidden key is taken off")
DOCS.eq(mail.pick(mail.parseArgs('""', false), rows), nil, "no subject and no sender picks nothing")
