-- Read a yes / no popup
--
-- ChoiceWindow() reads the game's yes / no popup (a rez offer, an invite, a zone-in question) - its text and both button labels - or nil when none is up.
--
-- kind:      snippet
-- expect:    Reads the popup's text and buttons; DoChoice answers false while EB holds that click back as not verified yet.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-choice-window

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.setWindow("choice", { text = "Accept a fixture resurrection?", choice1 = "Accept", choice2 = "Decline" })

-- your script
local game = require("eb.platform").game()
local cw = game.ChoiceWindow()
if cw then print(("popup: %s [%s / %s]"):format(cw.text, cw.choice1, cw.choice2)) end
-- DoChoice(1) presses the first button once EB has verified that click in game; until then it sends nothing
-- and answers false, so a script must not assume the popup was answered
local pressed = game.DoChoice(1)

-- check
DOCS.eq(cw.choice1, "Accept", "the first button's label")
DOCS.eq(pressed, false, "held back until verified: nothing was clicked")
DOCS.check(game.ChoiceWindow() ~= nil, "so the popup is still up")
