-- EB tested example: Patrol between saved marks (complete script)
-- script-patrol | complete script | topics: nav, helpers
--
-- What it does:  A drop-in script that walks you between marks you saved with eb marks set, for as many laps as you ask: it hands
--                each walk to EB (eb marks go) and watches you arrive before it sends the next.
-- Where it goes: InnerSpace/Scripts/eb_patrol.lua (save it as eb_patrol.lua)
-- Run it:        eb marks set alpha
--                eb marks set beta
--                lua eb_patrol alpha beta laps=2
--                endlua eb_patrol
-- Needs:         - EB for InnerSpace running in this session (eb status answers)
--                - each mark saved first with eb marks set <name>, standing on the spot, in this zone
--                - a mesh for this zone (EB walks the mesh and nothing else: a mark the mesh has no route to is not walked to)
-- Tested:        Walks to each mark in turn for the laps asked, says where it is after each walk, and ends on the last mark.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- eb_patrol.lua - walk between your saved marks. For each mark it sends EB the line "marks go <mark>" through EB's
-- console word (luacall EBISX_cmd: EB answers in the console, a script hears no reply), then watches you: the walk has
-- started once you move, and it is over once you stood still for a second. Then the next mark, lap after lap.
--
--   lua eb_patrol <mark> <mark> [<mark> ...] [laps=<n>]      start it (laps: default 1)
--   endlua eb_patrol                                           stop it (a walk EB has started finishes on its own)

local marks, laps = {}, 1
for _, a in ipairs({ ... }) do
    local n = tostring(a):match("^laps=(%d+)$")
    if n then
        laps = tonumber(n)
    elseif tostring(a):match("^[%w_%-]+$") then
        marks[#marks + 1] = a
    else
        echo("eb_patrol: a mark name is one word: " .. tostring(a))
        return
    end
end
if #marks < 2 then
    echo("usage: lua eb_patrol <mark> <mark> [<mark> ...] [laps=<n>]")
    return
end

local START_WAIT = 4          -- seconds to see the walk start
local WALK_MAX = 180          -- seconds one walk may take
local function moving() return IS.Parse("${Me.IsMoving}") == "TRUE" end

-- one walk: EB walks it; this only watches you start and stop
local function walkTo(mark)
    IS.Execute("luacall EBISX_cmd marks go " .. mark)
    if not waituntil(moving, START_WAIT) then
        echo("eb_patrol: no walk to " .. mark .. " (already there, no such mark in this zone, or the mesh has no way to it - EB says which in its console)")
        return
    end
    local still, spent = 0, 0
    while still < 1 and spent < WALK_MAX do
        wait(0.25)
        spent = spent + 0.25
        if moving() then still = 0 else still = still + 0.25 end
    end
end

echo(("eb_patrol: %d mark(s), %d lap(s) - endlua eb_patrol stops it"):format(#marks, laps))
for lap = 1, laps do
    for _, mark in ipairs(marks) do
        walkTo(mark)
        echo(("eb_patrol: lap %d, at %s"):format(lap, mark))
    end
end
echo("eb_patrol: done")
