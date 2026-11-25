-- Hand the brain a chore loop
--
-- eb.loops builds a chore loop as a brain goal: overseer, errands, trainer, mercenary or collections. Give it an activities provider (the window driver it acts through) and set it on the running brain; the brain advances it one bite per tick between its own interrupts. A trainer only ever spends points on abilities YOUR list names.
--
-- kind:      snippet
-- expect:    The brain runs the trainer pass on the booted box: it trains the listed ability with both points, claims finished research, and leaves the unlisted one alone.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.loops
-- id:        loop-trainer-goal

-- offline stand-in: EB booted on the offline world; the provider below stands in for the trainer window driver
local a = DOCS.app()
local points, trained, claimed = 2, {}, false
local provider = {
    near = function() return nil end,                          -- nil: no trainer NPC needed for these upgrades
    points = function() return { training = points, aa = 0 } end,
    trainable = function() return { { id = "t1", name = "Fixture Ward", kind = "training" },
                                    { id = "t2", name = "Fixture Bloom", kind = "training" } } end,
    train = function(id) trained[#trained + 1] = id; points = points - 1; return "done" end,
    researchClaim = function() claimed = true; return "done" end,
    researchStart = function() return "done" end,
    researchNext = function() return nil end,
}

-- your script
local Loops = require("eb.loops")
local brain = a.app.brain
brain:setGoal(Loops.new({ kind = "trainer", params = { act = { trainer = provider }, trainList = { "Fixture Ward" } } }))
a.w.runFor(5000)                                   -- the brain ticks about 4 times a second
for _, l in ipairs(a.app.brainLog) do if l:find("done", 1, true) then print(l:match("goal .*")) end end

DOCS.eq(#trained, 2, "both points were spent")
DOCS.eq(trained[1], "t1", "on the listed ability")
DOCS.eq(trained[2], "t1", "and only on it")
DOCS.check(claimed, "finished research was claimed (free, safe)")
DOCS.eq(brain:activeGoal(), nil, "the goal finished and left the brain idle")
a.stop()
