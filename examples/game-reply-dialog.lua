-- EB tested example: Answer an NPC's conversation
-- game-reply-dialog | snippet | topics: game, quests, helpers, dialogs
--
-- What it does:  ReplyDialog() reads the NPC conversation (the speech bubble or the classic dialog) and its reply options;
--                ReplyChoose(n, d) picks reply n.
-- Tested:        Picks the reply that offers the task, by its text, in the speech bubble.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.setWindow("reply", { text = "Hail, traveller.", bubble = true,
    options = { "Who are you?", "I can help with that.", "Farewell." } })

-- your script
local game = require("eb.platform").game()
local d = game.ReplyDialog()
if d and d.options then
    for i, text in ipairs(d.options) do
        if text:lower():find("help", 1, true) then
            game.ReplyChoose(i, d)                  -- pass the dialog back: a bubble reply is clicked, a classic one chosen
            print(("chose %d: %s"):format(i, text))
            break
        end
    end
end

-- check
DOCS.eq(d.replies, 3, "three replies offered")
DOCS.eq(w.world.windows.replyChosen, 2, "the second reply was picked")
