-- EB tested example: Pause EB when the bags are full (complete script)
-- script-bagwatch | complete script | topics: items, helpers, crew
--
-- What it does:  A drop-in script that pauses EB (this box, or the whole crew) when your bags drop under a number of free slots,
--                and resumes it once there is room again.
-- Where it goes: InnerSpace/Scripts/eb_bagwatch.lua (save it as eb_bagwatch.lua)
-- Run it:        lua eb_bagwatch free=3
--                lua eb_bagwatch free=3 crew
--                endlua eb_bagwatch
-- Needs:         - EB for InnerSpace running in this session (eb status answers)
-- Tested:        Pauses EB once when the free slots fall under the mark and resumes it once when you made room.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- eb_bagwatch.lua - stop EB filling bags it cannot empty. Every two seconds it reads how many bag slots are free (one
-- read). Under the mark it sends EB "pause" through EB's console word - "all pause" with the word crew, so every box
-- stops - and once you made room (two slots past the mark, so it does not flip back and forth) it sends "resume".
-- EB answers in the console; a script hears no reply.
--
--   lua eb_bagwatch [free=<slots>] [crew]      start it (free: default 3)
--   endlua eb_bagwatch                         stop it

local low, crew = 3, false
for _, a in ipairs({ ... }) do
    local n = tostring(a):match("^free=(%d+)$")
    if n then
        low = tonumber(n)
    elseif a == "crew" then
        crew = true
    else
        echo("usage: lua eb_bagwatch [free=<slots>] [crew]")
        return
    end
end

local paused = false
echo(("eb_bagwatch: pausing %s under %d free bag slot(s) - endlua eb_bagwatch stops it"):format(
    crew and "the crew" or "EB", low))
while true do
    local free = tonumber(IS.Parse("${Me.InventorySlotsFree}"))
    if free then
        if not paused and free < low then
            IS.Execute(crew and "luacall EBISX_cmd all pause" or "luacall EBISX_cmd pause")
            echo(("eb_bagwatch: %d bag slot(s) free - paused"):format(free))
            paused = true
        elseif paused and free >= low + 2 then
            IS.Execute(crew and "luacall EBISX_cmd all resume" or "luacall EBISX_cmd resume")
            echo(("eb_bagwatch: %d bag slot(s) free - resumed"):format(free))
            paused = false
        end
    end
    wait(2)
end
