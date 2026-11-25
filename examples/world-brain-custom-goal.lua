-- Give the brain your own goal
--
-- A goal is a phase machine the brain advances one bite per tick: return working, done or blocked; never wait.
--
-- kind:      snippet
-- expect:    The goal steps through count -> report -> done over four brain ticks, then the brain is idle.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.brain
-- id:        world-brain-custom-goal

-- offline stand-in: a world the brain can snapshot (in game EB builds the brain over eb.world itself)
local world = { snapshot = function() return { inGame = true, name = "Tankard", class = "guardian", zone = "a_test_hall",
    hpPct = 100, powerPct = 100, x = 0, y = 0, z = 0, group = { count = 0, members = {} } } end }

-- your script
local Brain = require("eb.brain")
local brain = Brain.new({ world = world }, { log = function() end })      -- missing subsystems get safe stubs
local goal = {
    name = "count-to-three", ctx = { phase = "count", n = 0 },
    advance = function(self, b, snap)
        local c = self.ctx
        if c.phase == "count" then
            c.n = c.n + 1
            if c.n >= 3 then c.phase = "report" end
            return "working"
        end
        return "done"
    end,
    describe = function(self) return "count[" .. self.ctx.phase .. "]" end,
}
brain:pushGoal(goal)
local t, ticks = 0, 0
while brain:activeGoal() and ticks < 20 do
    t = t + 50                                   -- the host calls pulse every frame; the brain ticks every 250 ms
    if brain:pulse(t) then ticks = ticks + 1 end
end
print(("goal done after %d ticks"):format(ticks))

-- check
DOCS.eq(ticks, 4, "three counts and one report")
DOCS.eq(brain:activeGoal(), nil, "the finished goal left the stack")
DOCS.eq(brain:pulse(t + 250), "idle", "the brain is idle")
