-- EB tested example: Goals, interrupts and one tick
-- world-goals-and-interrupts | snippet | topics: combat, helpers
--
-- What it does:  The brain's seven interrupts in priority order, a built-in goal's phase, and ticks stepped by hand: a fight
--                takes the tick while it is on, then the goal resumes where it was.
-- Tested:        death comes first; a grind goal starts in "select"; while a fight is on the combat interrupt takes the tick,
--                then the goal carries on.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local Brain = require("eb.brain")
local Goals = require("eb.brain.goals")
local Irq = require("eb.brain.interrupts")
local C = require("eb.brain.contracts")

local order = Irq.new()                                    -- highest priority first
local grind = Goals.new({ kind = "grind", params = { camp = { x = 0, y = 0, z = 0, radius = 40 }, maxKills = 1 } })

-- a brain over stand-in subsystems (in game EB's start gives it the real ones) and a world you control
local fightOn = true
local deps = C.stubs()
deps.world = { snapshot = function()
    return { inGame = true, hated = fightOn, x = 0, y = 0, z = 0, zone = "fixture_hollow", hpPct = 100,
             powerPct = 100, bagsFreeSlots = 20, group = { count = 1, members = {} } }
end }
local b = Brain.new(deps, { log = function() end })
b:pushGoal({ name = "watch", ctx = { phase = "look" },
             advance = function(self, brain, snap) return "working" end,
             describe = function(self) return "watch[look]" end })
local during = b:tick(0, 250)                              -- a fight is on: the combat interrupt has the tick
fightOn = false
local after = b:tick(250, 250)                             -- the fight is over: the goal goes on
print(("first: %s (%d) | %s | %s then %s"):format(order[1].name, order[1].priority, grind:describe(), during, after))

-- check
DOCS.eq(#order, 7, "seven interrupts")
DOCS.eq(order[#order].name, "low_hp_power", "resting comes last")
DOCS.eq(grind.preset, "openworld", "a grind goal sets the openworld preset")
DOCS.eq(during, "irq:combat/cleared", "the fight took the tick")
DOCS.eq(after, "goal:watch/working", "the goal resumed")
DOCS.has(b:status(), "watch[look]", "status names the goal and its phase")
