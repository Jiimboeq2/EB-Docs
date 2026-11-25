-- EB tested example: Pick a letter for OpenMail
-- quest-mail-pick | snippet | topics: quests, items
--
-- What it does:  The mail verbs pick a letter by its subject (and, when given, by the sender's whole name) at the nearest
--                mailbox. The rules are pure: parseArgs reads the verb's arguments, shown takes the game's hidden key off a
--                field, and pick finds the first letter that fits and counts how many do.
-- Tested:        The second letter fits the subject; the take word is read; the hidden key is taken off.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
