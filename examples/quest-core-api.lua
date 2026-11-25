-- EB tested example: Run a pack on the runner's core, with only your own verbs
-- quest-core-api | snippet | topics: quests
--
-- What it does:  eb.quest.quests is the runner without the verb families loaded: register the verbs you want, bind the core to
--                your adapters, and step a pack. Here a two-step pack of one custom verb runs to completion, and stepTarget reads
--                a move step's point without running it.
-- Tested:        Both chime steps finish, the pack completes, and stepTarget names the move step's point.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
