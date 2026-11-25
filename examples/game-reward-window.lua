-- EB tested example: Read a quest reward window
-- game-reward-window | snippet | topics: game, quests, dialogs
--
-- What it does:  RewardWindow() tells a granted reward (no choice) from a pick-one reward and from a new quest offer;
--                AcceptReward() takes it once EB has verified that click.
-- Tested:        Reads a single granted reward; AcceptReward answers false with its reason while the click is held back.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
