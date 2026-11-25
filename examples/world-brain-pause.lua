-- EB tested example: Pause the brain and read its status
-- world-brain-pause | snippet | topics: helpers, ui
--
-- What it does:  brain:pause() freezes goals (a fight still runs in the combat engine); status() is one line for a window.
-- Tested:        A paused brain answers "paused" and does not tick; resumed, it ticks again and status() names its goal.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
