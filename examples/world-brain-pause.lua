-- Pause the brain and read its status
--
-- brain:pause() freezes goals (a fight still runs in the combat engine); status() is one line for a window.
--
-- kind:      snippet
-- expect:    A paused brain answers "paused" and does not tick; resumed, it ticks again and status() names its goal.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.brain
-- id:        world-brain-pause

-- offline stand-in: a world the brain can snapshot
local world = { snapshot = function() return { inGame = true, name = "Tankard", class = "guardian", zone = "a_test_hall",
    hpPct = 88, powerPct = 100, x = 0, y = 0, z = 0, group = { count = 0, members = {} } } end }

-- your script
local brain = require("eb.brain").new({ world = world }, { log = function() end })
brain:pushGoal({ name = "watch", ctx = { phase = "watch" }, advance = function() return "working" end,
    describe = function() return "watch[watch]" end })
brain:pause()
print("paused -> " .. tostring(brain:pulse(1000)))
local ticksWhilePaused = brain.ticks
brain:pause(false)
local after = brain:pulse(2000)

-- check
DOCS.eq(ticksWhilePaused, 0, "no tick while paused")
DOCS.eq(after, "goal:watch/working", "resumed, it ticks the goal")
DOCS.has(brain:status(), "watch[watch]", "status() names the goal and its phase")
DOCS.has(brain:status(), "a_test_hall hp88", "and where it is")
