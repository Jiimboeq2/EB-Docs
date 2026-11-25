-- Run a pack on the runner's core, with only your own verbs
--
-- eb.quest.quests is the runner without the verb families loaded: register the verbs you want, bind the core to your adapters, and step a pack. Here a two-step pack of one custom verb runs to completion, and stepTarget reads a move step's point without running it.
--
-- kind:      snippet
-- expect:    Both chime steps finish, the pack completes, and stepTarget names the move step's point.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.quest.quests, eb.quest.verbs
-- id:        quest-core-api

local Q = require("eb.quest.quests")
local verbs = require("eb.quest.verbs")
local chimes = 0
verbs.register("chime", function(ctx) chimes = chimes + 1; return ctx:done("chimed") end, "chime once", "act")

local PACK = { schema = "eb-quest/1", quest_name = "Fixture Chimes", steps = {
    { type = "command", command = "Chime" }, { type = "command", command = "Chime" } } }

-- offline stand-in for the game's adapters
local deps = require("quests.lib.questworld").make()

-- your script
local api = Q.bind(deps)
local run = api.start({ quest = PACK, name = PACK.quest_name }, {})
local status
for _ = 1, 6 do status = Q.step(run); if status == "complete" or status == "blocked" then break end end
print(("chimed %d times, then: %s"):format(chimes, status))

local moveRun = api.start({ quest = { quest_name = "Fixture Walk", steps = { { command = "MM 4,0,5", zone = "Fixture Docks" } } } }, {})
local x, y, z, zone = Q.stepTarget(moveRun)

-- check
DOCS.eq(status, "complete", "the pack completed")
DOCS.eq(chimes, 2, "each chime step ran once")
DOCS.eq(x, 4, "stepTarget reads the move step's x")
DOCS.eq(z, 5, "and z")
DOCS.eq(zone, "Fixture Docks", "and its zone, without running it")
