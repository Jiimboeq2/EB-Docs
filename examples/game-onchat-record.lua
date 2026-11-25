-- Record chat lines from the game's own chat event
--
-- OnChat(fn) gives your function every chat line the moment the game raises it. That runs inside the game's event, so the function only records; the frame code acts on what it recorded.
--
-- kind:      snippet
-- expect:    The handler records the two lines; the frame code then counts the one from the named speaker.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game, eb.events
-- id:        game-onchat-record

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
