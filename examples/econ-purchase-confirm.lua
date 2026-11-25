-- Answer a purchase question only for your own item
--
-- The game asks "Are you sure you want to purchase X?" on some buys. confirm.asksFor(question, item) is true only when the question names exactly the item you are buying - the rule for pressing Yes; anything else is answered No or left alone.
--
-- kind:      snippet
-- expect:    The question about our own item matches; a question about another item does not.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.confirm
-- id:        econ-purchase-confirm

-- your script
local C = require("eb.economy.confirm")
local q = "Are you sure you want to purchase Fixture Stone?  This cannot be undone."
print(("ours: %s, someone else's: %s"):format(tostring(C.asksFor(q, "Fixture Stone")),
    tostring(C.asksFor(q, "Fixture Gem"))))

-- check
DOCS.eq(C.asksFor(q, "fixture stone"), true, "case does not matter")
DOCS.eq(C.asksFor("Join the fixture group?", "Fixture Stone"), false, "not a purchase question")
DOCS.eq(C.seconds(2), 20, "a wait under 5 s falls back to the default")
