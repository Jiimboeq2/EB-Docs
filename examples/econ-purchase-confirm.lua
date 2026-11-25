-- EB tested example: Answer a purchase question only for your own item
-- econ-purchase-confirm | snippet | topics: items, helpers, dialogs
--
-- What it does:  The game asks "Are you sure you want to purchase X?" on some buys. confirm.asksFor(question, item) is true only
--                when the question names exactly the item you are buying - the rule for pressing Yes; anything else is answered
--                No or left alone.
-- Tested:        The question about our own item matches; a question about another item does not.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local C = require("eb.economy.confirm")
local q = "Are you sure you want to purchase Fixture Stone?  This cannot be undone."
print(("ours: %s, someone else's: %s"):format(tostring(C.asksFor(q, "Fixture Stone")),
    tostring(C.asksFor(q, "Fixture Gem"))))

-- check
DOCS.eq(C.asksFor(q, "fixture stone"), true, "case does not matter")
DOCS.eq(C.asksFor("Join the fixture group?", "Fixture Stone"), false, "not a purchase question")
DOCS.eq(C.seconds(2), 20, "a wait under 5 s falls back to the default")
