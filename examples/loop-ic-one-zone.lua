-- EB tested example: Loop one instance: wait inside until it can be reset
-- loop-ic-one-zone | snippet | topics: tasks, instances
--
-- What it does:  runner:loop runs one instance again and again (until stopped by default; laps caps it here). Looping ONE zone,
--                the tank waits out the reuse timer INSIDE the cleared copy where the run ended, then leaves by the exit door,
--                resets the copy from outside and goes back in. The first lap is a rerun of the copy we stand in.
-- Tested:        Two laps run; the 5-minute wait happens inside the copy, every reset is done from outside, and the loop ends
--                with "laps done".
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local INSTANCE = {
    schema = "eb.ic/1", zone = "Fixture Hollow", short = "fixture_hollow",
    hub = { zone = "fixture_docks", entrance = { loc = { 0, 0, 0 }, tolerance = 8 },
            door = { actor = "a fixture rift", verb = "enter" } },
    route = {
        { id = "n1", act = "encounter", name = "captain_fixturo" },
        { id = "exit.walk", act = "path", spots = { { 0, 0, -38 } } },
        { id = "exit", act = "zoneout", via = "exit" },
    },
    loop = { reset = "self", rerun_first = true },      -- the defaults: until stopped, first lap a rerun
}
local CAPTAIN = { schema = "eb.ic/1", name = "Captain Fixturo", kind = "named",
                  phases = { { do_ = { { engage = "Captain Fixturo" } } } } }

-- offline stand-in: we stand inside a copy we just cleared; it can be reset in 5 minutes, and 0 after each lap
local env, world = require("instances.lib.icworld").make({ start = "copy", reuseNow = 300, reuse = { 0, 0, 0 },
    alive = { ["Captain Fixturo"] = 100 } })
env.loadInstance = function() return INSTANCE end
env.loadEncounter = function() return CAPTAIN end

local runner = require("eb.ic").new(env)
local ok, why, report = runner:loop(assert(runner:load("fixture_hollow")), { laps = 2 })
for _, l in ipairs(world.lines) do if l:find("waiting INSIDE", 1, true) then print(l) end end

DOCS.check(ok, "the loop ended cleanly: " .. tostring(why))
DOCS.eq(why, "laps done", "after the two laps asked for")
DOCS.eq(report.laps, 2, "two laps")
DOCS.check(world.said("waiting INSIDE the cleared copy"), "the timer was waited out inside")
for _, c in ipairs(world.calls) do
    if c[1] == "reset" then DOCS.eq(c[3], "fixture_docks", "every reset is done from outside the copy") end
end
DOCS.check(world.did("reset") >= 2, "a reset before each lap")
