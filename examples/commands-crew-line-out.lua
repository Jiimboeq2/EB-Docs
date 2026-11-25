-- A crew line leaves this box
--
-- Typed with a crew scope, a line runs here and goes out on the crew relay for every other box.
--
-- kind:      snippet
-- expect:    eb all pause pauses this box and puts one crew line on the relay; eb resume (no scope) stays here.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.app, eb.registry
-- id:        commands-crew-line-out

-- offline stand-in: the whole of EB for InnerSpace booted by its real boot (in game: type it in the console)
local a = DOCS.app()
local function crewLines()                 -- offline: count what left this box on the relay
    local n = 0
    for _, item in ipairs(a.host.log.relay) do if item.kind == "event" and item.name:match("Cmd$") then n = n + 1 end end
    return n
end

-- your script
local before = crewLines()
a.console("eb all pause")
local out = crewLines() - before
print("crew lines out: " .. out)
local pausedHere = a.app.brain.paused
a.console("eb resume")

-- check
DOCS.eq(out, 1, "one crew line went out")
DOCS.eq(pausedHere, true, "and the line ran here too")
DOCS.eq(crewLines() - before, 1, "eb resume (no scope) did not go out")
DOCS.check(not a.app.brain.paused, "resumed here")
a.stop()
