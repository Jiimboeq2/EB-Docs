-- EB tested example: Open one letter by its subject and take what it carries
-- econ-mail-open-letter | snippet | topics: items, quests
--
-- What it does:  A letter is picked by a part of its subject, by its sender's WHOLE name, or both - a part of a name never
--                matches. The game may put a key in front of a subject (":<key>:"); it is never part of it. mail.pick is the pure
--                rule; eco.mail:open(subject, sender, take) opens the first letter that fits and, with take, takes its
--                attachments. A quest letter opened this way starts its quest.
-- Tested:        The keyed subject is matched, "Fix" does not match the sender "Fixwell", and the lantern oil reaches the bags.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({ inbox = {
    { id = 1, from = "Fixwell", subject = "A note", attachments = {} },
    { id = 2, from = "Lamplighter Fixto", subject = ":0123abcd:The Fixture Lantern",
      attachments = { { name = "Fixture Lantern Oil", qty = 1 } } },
} })
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me })
local Mail = require("eb.economy.mail")

-- your script: the pure rules first
DOCS.eq(Mail.shown(":0123abcd:The Fixture Lantern"), "The Fixture Lantern", "the key is not part of the subject")
DOCS.eq((Mail.pick("lantern", nil, W.mail.inbox)), 2, "a part of the subject matches")
DOCS.eq((Mail.pick(nil, "Fix", W.mail.inbox)), nil, "a part of a name never matches")
DOCS.eq((Mail.pick(nil, "fixwell", W.mail.inbox)), 1, "the whole name, any case, does")

-- open it and take the attachment
local status
for _ = 1, 20 do
    status = eco.mail:open("lantern", nil, true)
    if status ~= "working" then break end
end
print("opened: " .. Mail.shown(W.mail.inbox[2].subject))

-- check
DOCS.eq(status, "done", "opened and taken")
DOCS.check(W.mail.inbox[2].read, "the letter was read")
local oil = false
for _, it in ipairs(W.bags) do if it.name == "Fixture Lantern Oil" then oil = true end end
DOCS.check(oil, "the attachment is in the bags")
