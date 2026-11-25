-- A window's verbs, its open and close, and the push budget
--
-- An ebkit window lists its verbs, hears when its page opens and closes, cleans what a page sends (str, args), and the push budget's classes and report say how often each window may send.
--
-- kind:      snippet
-- expect:    The window lists its two verbs, counts one open and one close, refuses a name that is too long, and the budget report counts its windows.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   ebkit.window, ebkit.push_budget
-- id:        ui-window-and-budget-tour

-- your script
local Window = require("ebkit.window")
local Budget = require("ebkit.push_budget")
local seen = { open = 0, close = 0 }
local win = Window.new({ id = "fixture-board", title = "Fixture board",
    build = function(w) return { greeting = w.data.greeting or "" } end,
    verbs = {                                     -- a verb gets (args, win) and answers at once
        greet = function(a, w)
            local name = Window.str(a.name, 12)          -- trimmed text, or nil when not text or too long
            if not name then return false, "a name of 1 to 12 letters" end
            w.data.greeting = "hello " .. name
            return true, "ok"
        end,
        clear = function(a, w) w.data.greeting = nil; return true, "cleared" end,
    },
    open = function() seen.open = seen.open + 1 end, close = function() seen.close = seen.close + 1 end,
    clock = function() return 0 end })
win.data = {}
local names = win:verbNames()
win:opened()
local tooLong = { win:verb("greet", Window.args({ name = "Fixturae Fixturae" })) }
win:verb("greet", Window.args({ name = "  Fixturae " }))
win:closed()
local g = Budget.gate(win, { class = "panel", clock = Budget.defaultClock() })
local rep = Budget.report()
print(("verbs: %s | opened %d, closed %d | panel every %d ms"):format(table.concat(names, ", "), seen.open, seen.close,
    Budget.CLASSES.panel.ms))

-- check
DOCS.eq(#names, 2, "two verbs")
DOCS.eq(tooLong[1], false, "a name over 12 characters is refused")
DOCS.eq(win:state().greeting, "hello Fixturae", "str trimmed the spaces")
DOCS.eq(type(Window.args("not a table")), "table", "args always hands a verb a table")
DOCS.check(type(rep.windows) == "table", "the report lists the gated windows")
DOCS.check(g ~= nil, "a gate for the window")
