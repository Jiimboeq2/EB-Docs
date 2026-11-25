-- Read a quest reward window
--
-- RewardWindow() tells a granted reward (no choice) from a pick-one reward and from a new quest offer; AcceptReward() takes it once EB has verified that click.
--
-- kind:      snippet
-- expect:    Reads a single granted reward; AcceptReward answers false with its reason while the click is held back.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-reward-window

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.setWindow("reward", { title = "Quest Complete", rewards = { { name = "a fixture trinket", linkId = 777 } } })

-- your script
local game = require("eb.platform").game()
local rw = game.RewardWindow()
if rw then print(("reward window: %s, %d granted"):format(rw.state, rw.grantedCount)) end
local ok, why = game.AcceptReward()           -- a pick-one window needs a name: game.AcceptReward("a fixture trinket")
if not ok then print("not accepted: " .. tostring(why)) end

-- check
DOCS.eq(rw.state, "no_choice", "one granted reward, nothing to pick")
DOCS.eq(ok, false, "held back until verified")
DOCS.check(type(why) == "string" and why ~= "", "and it says why")
