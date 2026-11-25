-- EB tested example: A crew line leaves this box
-- commands-crew-line-out | snippet | topics: commands, crew
--
-- What it does:  Typed with a crew scope, a line runs here and goes out on the crew relay for every other box.
-- Tested:        eb all pause pauses this box and puts one crew line on the relay; eb resume (no scope) stays here.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
