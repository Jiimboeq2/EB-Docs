-- EB tested example: Recipe: an instance route with steps, pulls and a camp spot
-- recipe-ic-route | snippet | topics: recipes, instances
--
-- What it does:  Write an instance file (hub, door, route steps, two encounter scripts), load it and run it end to end: the tank
--                zones in, camps the group, walks, pulls a named, clears the trash, loots, announces and leaves by the exit door.
-- Tested:        The run completes: the named is killed, the trash cleared, the chest looted, the door used once and the exit
--                taken back to the hub.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- the instance file: what instance.lua returns (pure data, nothing runs at load)
local INSTANCE = {
    schema = "eb.ic/1",
    zone = "Fixture Hollow", short = "fixture_hollow",
    hub = {                                                 -- getting in: every box reaches the hub on its own,
        zone = "fixture_docks", difficulty = "[Heroic I]",  -- the tank alone walks to the door and zones the group in
        approach = { { 10, 0, 10 }, { 20, 0, 25 } },
        entrance = { loc = { 20, 0, 25 }, tolerance = 8 },
        door = { actor = "a fixture rift", verb = "enter" },
    },
    rules = "default",                                      -- arm the character's own cast stack
    encounters = { "captain_fixturo", "hollow_skitters" },
    route = {                                               -- the STEPS the tank runs, in order
        { id = "camp.entry", act = "campspot", name = "entry", spot = { 0, 0, -30 }, who = "group" },
        { id = "n1.walk", act = "path", spots = { { 0, 0, 10 }, { 15, 0, 40 } } },
        { id = "n1", act = "encounter", name = "captain_fixturo" },
        { id = "n1.loot", act = "loot", op = "chest" },
        { id = "trash", act = "encounter", name = "hollow_skitters" },
        { id = "said", act = "announce",
          message = "Fixture Hollow: {{verdict.n1}} / {{verdict.trash}} (chest {{verdict.n1.loot}})" },
        { id = "exit.walk", act = "path", spots = { { 0, 0, -38 } } },
        { id = "exit", act = "zoneout", via = "exit" },
    },
}

-- the encounter files: what encounters/<name>.lua return (conditions -> actions)
local ENCOUNTERS = {
    captain_fixturo = {
        schema = "eb.ic/1", name = "Captain Fixturo", kind = "named", spot = { 15, 0, 42 },
        phases = { { id = "pull", do_ = { { target = { "Captain Fixturo" } }, { engage = "Captain Fixturo" } } } },
        done = { { actor_dead = "Captain Fixturo" } },
    },
    hollow_skitters = {
        schema = "eb.ic/1", name = "a hollow skitter", kind = "trash",
        when = { { actor_count = { query = "a hollow skitter", cmp = ">=", value = 1 } } },   -- no pack = skipped
        phases = { { id = "clear", do_ = { { clear_area = "a hollow skitter", radius = 30 } } } },
    },
}

-- offline stand-in for the game (in game EB hands the runner its live nav, combat engine and crew)
local env, world = require("instances.lib.icworld").make({
    alive = { ["Captain Fixturo"] = 100 }, packs = { ["a hollow skitter"] = 4 }, drops = { "a fixture chest" } })
env.loadInstance = function() return INSTANCE end                    -- the file above, instead of a folder on disk
env.loadEncounter = function(_, name) return ENCOUNTERS[name] end

-- your script
local IC = require("eb.ic")
local runner = IC.new(env)
local inst = assert(runner:load("fixture_hollow"))
local ok, why, report = runner:run(inst)
print(why)
for _, line in ipairs(world.lines) do
    local said = line:match("ANNOUNCE: (.*)$")
    if said then print(said) end
end

-- check
DOCS.check(ok, "the run completes: " .. tostring(why))
DOCS.eq(report.verdicts.n1, "killed", "the named")
DOCS.eq(report.verdicts.trash, "cleared", "the trash pack")
DOCS.eq(report.verdicts["n1.loot"], "a fixture chest", "the chest")
DOCS.eq(world.did("door"), 1, "the door was used once, by the tank")
DOCS.eq(world.did("camp"), 1, "one camp spot for the group")
DOCS.eq(world.zone, "fixture_docks", "out by the exit door, back in the hub")
