-- EB tested example: Write long work as a pollable job
-- econ-job-steps | snippet | topics: tasks, items, helpers
--
-- What it does:  An economy Job cuts long work into steps and runs one bite per call: a step answers "stay" (still on it), "next"
--                (move on), "done" (finish early) or "blocked" with a reason, and keeps its progress in job.mem. Call job:tick
--                once per tick - from a pulse job is fine, a tick never waits - until it is no longer "working".
-- Tested:        The three-step job reports working for each bite, then done; a step that raises ends the job as blocked instead
--                of breaking the frame.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local Job = require("eb.economy.job")

-- your script: walk to the vendor, sell three items one per tick, close the window
local sold = 0
local job = Job.new("fixture-sell", {
    function(j, ctx) return ctx.atVendor and "next" or "stay" end,
    function(j, ctx)
        j.mem.i = (j.mem.i or 0) + 1                         -- this step's own scratch
        sold = sold + 1
        if j.mem.i < #ctx.items then return "stay" end
        return "next"
    end,
    function() return "done" end,
})
local ctx = { atVendor = false, items = { "a fixture cup", "a fixture plate", "a fixture fork" } }
local trace = {}
for t = 1, 10 do
    if t == 2 then ctx.atVendor = true end                  -- the walk arrives on the second tick
    local st = job:tick(ctx)
    trace[#trace + 1] = st
    if job:finished() then break end
end
print(("sold %d of %d, then: %s"):format(sold, #ctx.items, trace[#trace]))

local broken = Job.new("broken", { function() error("the vendor window closed") end })
local bst, bwhy = broken:tick({})

-- check
DOCS.eq(trace[1], "working", "the first tick waits for the walk")
DOCS.eq(trace[#trace], "done", "the job ends done")
DOCS.eq(sold, 3, "one sale per tick")
DOCS.eq(job:tick(ctx), "done", "an extra tick after the end does not restart it")
DOCS.eq(bst, "blocked", "a step that raises ends the job")
DOCS.has(bwhy, "the vendor window closed", "with the error as its reason")
DOCS.eq(job:reset().i, 1, "reset starts it over at the first step")
