-- Add your own pack verb
--
-- eb.quest.verbs.register(keys, fn, about, group) adds a verb every pack can use. The handler gets the step's context: ctx.cmd (the parsed line), ctx:zone(), ctx.state (this step's own scratch table) and answers with ctx:done, ctx:work, ctx:travel, ctx:combat, ctx:loot, ctx:block or ctx:stop. It must return at once and never wait.
--
-- kind:      snippet
-- expect:    The custom verb waits two ticks while it rings, then the pack goes on and completes.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.quest.verbs, eb.quest
-- id:        quest-custom-verb

local verbs = require("eb.quest.verbs")
verbs.register({ "ringgong", "gong" }, function(ctx)
    local times = tonumber(verbs.csv(ctx.cmd.rest)[1]) or 1
    ctx.state.rung = (ctx.state.rung or 0) + 1                 -- per-step scratch, kept across ticks
    if ctx.state.rung < times then return ctx:work("ringing (" .. ctx.state.rung .. "/" .. times .. ")") end
    return ctx:done(("rang the fixture gong %d times in %s"):format(times, tostring(ctx:zone())))
end, "ring the fixture gong N times (a docs example verb)", "act")

local PACK = { schema = "eb-quest/1", quest_name = "Fixture Gong", steps = {
    { type = "command", command = "RingGong 3" },
    { type = "command", command = "MM 1,0,1" } } }
local deps, world = require("quests.lib.questworld").make()
local quests = require("eb.quest").bind(deps)
local run = quests.start({ quest = PACK, name = PACK.quest_name }, {})
local trace, msg = {}, nil
for _ = 1, 10 do
    local st, info = quests.step(run)
    trace[#trace + 1] = st
    if st == "step_done" and tostring(info):find("gong", 1, true) then msg = info end
    if st == "complete" or st == "blocked" then break end
end
print(msg)

DOCS.check(require("eb.quest").supported("ringgong"), "the new verb is supported")
DOCS.eq(trace[1], "working", "tick 1: still ringing")
DOCS.eq(trace[3], "step_done", "tick 3: rung three times")
DOCS.eq(trace[#trace], "complete", "the pack goes on and completes")
