-- EB tested example: Read a yes / no popup
-- game-choice-window | snippet | topics: game, events, helpers, dialogs
--
-- What it does:  ChoiceWindow() reads the game's yes / no popup (a rez offer, an invite, a zone-in question) - its text and both
--                button labels - or nil when none is up.
-- Tested:        Reads the popup's text and buttons; DoChoice answers false while EB holds that click back as not verified yet.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
