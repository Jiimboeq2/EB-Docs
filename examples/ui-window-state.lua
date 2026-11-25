-- Build a window's state
--
-- An ebkit window builds its WHOLE state as a plain table, and returns the SAME table until something changes.
--
-- kind:      snippet
-- expect:    Two state() calls give the same table and one build; touch() makes the next state() build a new one.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   ebkit.window
-- id:        ui-window-state

-- your script
local W = require("ebkit.window")
local kills, builds = 0, 0
local win = W.new({
    id = "killcounter", title = "Kill Counter", about = "kills this session",
    build = function(self)                       -- called only after a change: build from your data, never the game
        builds = builds + 1
        return { kills = kills, label = kills == 1 and "1 kill" or (kills .. " kills") }
    end,
})
local a, b = win:state(), win:state()
local first = builds
kills = 3
win:touch()                                       -- "something it shows changed"
local c = win:state()
print(("builds: %d, then %d after touch"):format(first, builds))

-- check
DOCS.check(a == b, "the same table while nothing changed: the window bridge sends nothing")
DOCS.eq(first, 1, "one build")
DOCS.eq(c.label, "3 kills", "a fresh state after touch")
DOCS.check(c ~= a, "a new table, so the bridge sends it")
