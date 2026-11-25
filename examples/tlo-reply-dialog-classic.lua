-- The classic conversation window
--
-- When an NPC opens the classic dialog (not the speech bubble), ReplyDialog.Text is what it says and its replies are listed through Replies:GetOptions. game.ReplyDialog() does both and ReplyChoose(n, d) answers.
--
-- kind:      snippet
-- expect:    Reads the classic dialog's text and its three replies, then answers with the second.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        tlo-reply-dialog-classic

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.setWindow("reply", { text = "Classic fixture greeting.", options = { "Who are you?", "Show me.", "Bye." },
    bubble = false })

-- your script
local game = require("eb.platform").game()
local d = game.ReplyDialog()
if d then
    print(("%s (%d replies)"):format(d.text, d.replies))
    game.ReplyChoose(2, d)
end

-- check
DOCS.eq(IS.Parse("${ReplyDialog.Text}"), "NULL", "the window closed once answered")
DOCS.eq(d.replies, 3, "three replies")
DOCS.eq(w.host.log.exec[#w.host.log.exec], "ReplyDialog:Choose[2]", "the second reply was chosen")
