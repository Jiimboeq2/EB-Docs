-- EB tested example: Build a window's state
-- ui-window-state | snippet | topics: ui, perf
--
-- What it does:  An ebkit window builds its WHOLE state as a plain table, and returns the SAME table until something changes.
-- Tested:        Two state() calls give the same table and one build; touch() makes the next state() build a new one.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
