-- EB tested example: Who is still elsewhere, and one copy for the door
-- ic-group-stragglers | snippet | topics: instances, crew
--
-- What it does:  Before the door the tank waits for the group in the hub. runner:stragglers names every member still in another
--                zone (by role or box id, never by character), and runner:sameCopy asks the brain to bring a group split across
--                copies of the hub into the tank's copy - nobody walks for it.
-- Tested:        One member is still on its way; after the brain gathers the group into one copy the door can go ahead.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game: the tank in the hub, a healer still travelling, the group split across two copies
local ICW = require("instances.lib.icworld")
local env, world = ICW.make({ group = { { id = "is2", role = "healer", zone = "fixture_vale" },
                                        { id = "is3", role = "dps", zone = "fixture_docks" } } })
local sameCopy, gathered = false, 0
env.brain.sameCopyAsGroup = function() return sameCopy end
env.brain.gatherToMyCopy = function() gathered = gathered + 1; sameCopy = true; return true end

-- your script
local runner = require("eb.ic").new(env)
local inst = { zone = "Fixture Hollow", short = "fixture_hollow", hub = { zone = "fixture_docks" }, route = {} }
local ctx = runner:newCtx(inst)
local missing = runner:stragglers(ctx, "fixture_docks", "Fixture Docks")
for _, m in ipairs(missing) do print(("still elsewhere: %s (in %s)"):format(m.label, m.zone)) end
local goOn = runner:sameCopy(ctx)

-- check
DOCS.eq(#missing, 1, "one member is not in the hub")
DOCS.eq(missing[1].id, "is2", "the healer's box")
DOCS.eq(goOn, true, "the door goes ahead")
DOCS.eq(gathered, 1, "the brain was asked once to bring the group into the tank's copy")
DOCS.eq(world.did("walk"), 0, "nobody walked for it")
