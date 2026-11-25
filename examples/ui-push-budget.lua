-- EB tested example: Cap how often a window's state goes out
-- ui-push-budget | snippet | topics: ui, perf
--
-- What it does:  ebkit.push_budget gates a window: a change too soon after the last one is held and the newest goes out next.
-- Tested:        A panel changing every 50 ms for a second emits at 0, 200, 400, 600 and 800 ms; the rest are held.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
