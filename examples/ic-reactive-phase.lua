-- EB tested example: A mechanic mid-fight: a reactive phase
-- ic-reactive-phase | snippet | topics: instances, fights
--
-- What it does:  An encounter whose boss calls in adds: a phase with when + repeat_ is checked on every fight tick and between
--                phases, and clears the adds whenever they are up, while the main phase fights the boss.
-- Tested:        The reactive phase fires once the adds surface, clears them, and the boss is killed.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local INSTANCE = {
    schema = "eb.ic/1", zone = "Fixture Hollow", short = "fixture_hollow",
    route = { { id = "boss", act = "encounter", name = "mire_queen" } },
}
local MIRE_QUEEN = {
    schema = "eb.ic/1", name = "Mire Queen Fixtura", kind = "boss",
    phases = {
        { id = "burn", do_ = { { engage = "Mire Queen Fixtura" } } },
        -- REACTIVE: when + repeat_ = checked on every fight tick; it fires whenever its condition holds
        { id = "adds", repeat_ = true,
          when = { { actor_count = { query = "a mire spawn", cmp = ">=", value = 1 } } },
          do_ = { { clear_area = "a mire spawn", radius = 25 } } },
    },
    done = { { actor_dead = "Mire Queen Fixtura" } },
}

-- offline stand-in: engaging the queen surfaces three adds
local env, world = require("instances.lib.icworld").make({ start = "copy",
    alive = { ["Mire Queen Fixtura"] = 100 }, adds = { on = "Mire Queen Fixtura", name = "a mire spawn", count = 3 } })
env.loadInstance = function() return INSTANCE end
env.loadEncounter = function() return MIRE_QUEEN end

local runner = require("eb.ic").new(env)
local inst = assert(runner:load("fixture_hollow"))
local ok, _, report = runner:run(inst)
for _, l in ipairs(world.lines) do if l:find("reactive", 1, true) then print(l) end end

DOCS.check(ok, "the run completes")
DOCS.eq(report.verdicts.boss, "killed", "the boss")
DOCS.eq(world.did("clear"), 1, "the adds were cleared once, when they surfaced")
DOCS.eq(env.combat.count("a mire spawn"), 0, "no add left up")
