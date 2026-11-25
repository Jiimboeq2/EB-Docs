-- EB tested example: Record chat lines from the game's own chat event
-- game-onchat-record | snippet | topics: game, events
--
-- What it does:  OnChat(fn) gives your function every chat line the moment the game raises it. That runs inside the game's event,
--                so the function only records; the frame code acts on what it recorded.
-- Tested:        The handler records the two lines; the frame code then counts the one from the named speaker.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()

-- your script (eb.events' ChatLine is the easier choice: its handlers run in EB's frame, where they may act)
local game = require("eb.platform").game()
local inbox = {}
game.OnChat(function(ev) inbox[#inbox + 1] = ev end)            -- record only: never wait or act in here
w.host:emitChat({ chatType = 8, speaker = "Questfixture", message = "Bring me three fixture pelts." })
w.host:emitChat({ chatType = 8, speaker = "Someonefixture", message = "hello" })
local n = 0
for _, ev in ipairs(inbox) do if ev.speaker == "Questfixture" then n = n + 1 end end
print(("%d line from Questfixture"):format(n))

-- check
DOCS.eq(#inbox, 2, "both lines recorded")
DOCS.eq(inbox[1].message, "Bring me three fixture pelts.", "the text")
DOCS.eq(n, 1, "one from the speaker we care about")
