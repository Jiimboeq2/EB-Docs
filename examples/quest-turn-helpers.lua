-- A pack verb that reads the journal and the world
--
-- A verb's handler gets the step's context. Besides the statuses it can answer, the context reads for it: ctx:completedDone() (the step's completed line is done in the journal), ctx:truth(condition), ctx:zoneEqual, ctx:groupCount() and ctx:inGuildHall(); ctx:log writes a line to the run's log.
--
-- kind:      snippet
-- expect:    The verb lights the lantern once, waits for the journal, and its step is done when the journal says so.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.quest.verbs, eb.quest
-- id:        quest-turn-helpers

local verbs = require("eb.quest.verbs")
verbs.register("lightlantern", function(ctx)
    if ctx:completedDone() then return ctx:done("the journal says the lantern is lit") end
    if ctx:truth("${Me.Level} >= 20") ~= true then return ctx:stop("too low for the lantern") end
    if not ctx:zoneEqual(ctx:zone(), "Fixture Docks") then return ctx:travel("Fixture Docks") end
    if not ctx.state.clicked then
        ctx.state.clicked = true
        ctx.dep.act.click({ name = "a fixture lantern", double = true })
        ctx:log("lit the lantern in %s (level gate passed, %s)", ctx:zone(), ctx:groupCount() == 1 and "solo" or "grouped")
    end
    return ctx:work("waiting for the journal")
end, "light the fixture lantern (a docs example verb)", "act")

local PACK = { schema = "eb-quest/1", quest_name = "Fixture Lanterns", continues_later = true, steps = {
    { type = "command", command = "LightLantern", completed = "Light the fixture lantern" } } }

-- offline stand-in for the game: the journal holds the line; clicking the lantern ticks it on the next tick
local deps, world = require("quests.lib.questworld").make({
    onClick = function(spec, w) w.journal.check("Fixture Lanterns", "Light the fixture lantern") end })
world.journal.give("Fixture Lanterns", { "Light the fixture lantern" })

-- your script
local quests = require("eb.quest").bind(deps)
local run = quests.start({ quest = PACK, name = PACK.quest_name }, {})
local trace = {}
for _ = 1, 6 do
    local st = quests.step(run)
    trace[#trace + 1] = st
    if st == "complete" or st == "blocked" then break end
    world.tick(1000)
end
print(world.lines[1])

-- check
DOCS.eq(world.did("click"), 1, "the lantern was clicked once")
DOCS.eq(trace[1], "working", "then the step waited for the journal")
DOCS.eq(trace[#trace], "complete", "and the pack completed once the journal said so")
DOCS.has(world.lines[1], "Fixture Docks", "ctx:log wrote to the run's log")
