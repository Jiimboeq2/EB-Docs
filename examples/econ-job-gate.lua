-- EB tested example: One job per request: call it every tick, it resumes
-- econ-job-gate | snippet | topics: tasks, items
--
-- What it does:  Job.gate keeps one live job per key on a table you own, so an action called every tick with the same request
--                resumes its job instead of starting over, and a different key is a separate job. Job.live finds a running one
--                without building, Job.clear drops them, and a stop flag on holder.env.stop ends a gated job at once.
-- Tested:        Three calls advance the same job; a stop ends a second one as blocked; clear forgets them.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local Job = require("eb.economy.job")

-- your script: an action that is safe to call every tick
local stop = false
local pillar = { env = { stop = function() return stop end } }
local function restock()
    return Job.gate(pillar, "restock:food", function()
        return Job.new("restock", { function() return "next" end, function() return "next" end, function() return "done" end })
    end):tick()
end
local a, b, c = restock(), restock(), restock()
print(("restock: %s, %s, %s"):format(a, b, c))

local sweep = Job.gate(pillar, "sweep", function() return Job.new("sweep", { function() return "stay" end }) end)
sweep:tick()
local running = Job.live(pillar, "sweep")
stop = true
local st, why = sweep:tick()
Job.clear(pillar)

-- check
DOCS.eq(c, "done", "the same job ran through its three steps")
DOCS.eq(running, sweep, "Job.live finds the running job")
DOCS.eq(st, "blocked", "the stop flag ends a gated job at once")
DOCS.eq(why, "stop requested", "and says why")
DOCS.eq(Job.live(pillar, "sweep"), nil, "clear dropped every job")
