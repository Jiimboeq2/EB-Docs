-- One job per request: call it every tick, it resumes
--
-- Job.gate keeps one live job per key on a table you own, so an action called every tick with the same request resumes its job instead of starting over, and a different key is a separate job. Job.live finds a running one without building, Job.clear drops them, and a stop flag on holder.env.stop ends a gated job at once.
--
-- kind:      snippet
-- expect:    Three calls advance the same job; a stop ends a second one as blocked; clear forgets them.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.job
-- id:        econ-job-gate

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
