-- Register a window with EB's window bridge
--
-- P.ui().register(win) adds your window to the bridge at run time; P.ui().adapter(win) is what the bridge sees.
--
-- kind:      snippet
-- expect:    The window registers, and its adapter answers state() and exposes exactly the window's verbs.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.platform, ebkit.window
-- id:        ui-register-window

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()

-- your script
local P = require("eb.platform")
local W = require("ebkit.window")
local kills = 0
local win = W.new({ id = "killcounter", title = "Kill Counter", about = "kills this session",
    build = function() return { kills = kills } end,
    verbs = { reset = function() kills = 0; return true, "cleared" end } })
local ok, why = P.ui().register(win)
print(("registered %s: %s"):format(win.id, tostring(ok)))
local adapter = P.ui().adapter(win)
local opened, whyNot = P.ui().open(win)       -- in game the window shows; offline there is no window host
kills = 2
win:touch()

-- check
DOCS.check(ok, "registered: " .. tostring(why))
DOCS.eq(adapter.state().kills, 2, "the bridge reads the window's state")
DOCS.eq(adapter.about, "kills this session", "and what it is about")
DOCS.check(adapter.verbs.reset ~= nil and adapter.verbs.unknown_verb == nil, "only the window's own verbs")
DOCS.eq(select(2, adapter.verbs.reset({})), "cleared", "a verb through the adapter")
DOCS.check(opened or type(whyNot) == "string", "open answers whether the window showed, and why not")
DOCS.eq(type(win.clock), "function", "registering gave the window EB's clock (its spec brought none)")
