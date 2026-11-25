-- Cap how often a window's state goes out
--
-- ebkit.push_budget gates a window: a change too soon after the last one is held and the newest goes out next.
--
-- kind:      snippet
-- expect:    A panel changing every 50 ms for a second emits at 0, 200, 400, 600 and 800 ms; the rest are held.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   ebkit.push_budget, ebkit.window
-- id:        ui-push-budget

-- your script
local W = require("ebkit.window")
local budget = require("ebkit.push_budget")
budget.reset()
local t, n = 0, 0
local win = W.new({ id = "busypanel", build = function() return { n = n } end })
local gate = budget.gate(win, { class = "panel", clock = function() return t end, phase = 0 })

for step = 1, 20 do                       -- the data changes every 50 ms for one second
    n = step
    win:touch()
    gate.state()                          -- what the window bridge calls instead of win:state()
    t = t + 50
end
local st = gate.stats()
print(("emits %d, held %d"):format(st.emits, st.held))

-- check
DOCS.eq(st.class, "panel", "a panel's cadence")
DOCS.eq(st.ms, 200, "is 200 ms")
DOCS.eq(st.emits, 5, "one emit per 200 ms")
DOCS.eq(st.emits + st.held, 20, "every change was either sent or held")
