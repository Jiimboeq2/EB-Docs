-- Answer an NPC's conversation
--
-- ReplyDialog() reads the NPC conversation (the speech bubble or the classic dialog) and its reply options; ReplyChoose(n, d) picks reply n.
--
-- kind:      snippet
-- expect:    Picks the reply that offers the task, by its text, in the speech bubble.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-reply-dialog

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
