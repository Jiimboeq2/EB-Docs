-- EB tested example: The classic conversation window
-- tlo-reply-dialog-classic | snippet | topics: tlos, quests, dialogs
--
-- What it does:  When an NPC opens the classic dialog (not the speech bubble), ReplyDialog.Text is what it says and its replies
--                are listed through Replies:GetOptions. game.ReplyDialog() does both and ReplyChoose(n, d) answers.
-- Tested:        Reads the classic dialog's text and its three replies, then answers with the second.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
