-- Crew, follow me (complete script)
--
-- A drop-in script for the box you drive by hand: it tells every other EB box to follow you, and tells them again after each zone load, so the boxes that came through with you pick the follow back up.
--
-- kind:      complete script
-- file:      InnerSpace/Scripts/eb_followme.lua
-- run:       lua eb_followme 4
--            endlua eb_followme
-- needs:     EB for InnerSpace running on this box and on the crew's boxes (eb status crew lists them)
--            the crew in your group, in the same zone as you
-- expect:    Sends eb others follow <you> at start and again after a zone load; this box itself never follows.
-- verified:  on the offline stand-in for the game
-- id:        script-followme

-- eb_followme.lua - the crew follows the box you drive.
--
--   lua eb_followme [metres]     start it on YOUR box: how close they keep (EB's own follow distance if left out)
--   endlua eb_followme           stop re-sending (each box keeps following until its EB stops or walks elsewhere)
--
-- It sends ONE crew line - `eb others follow <your name> [metres]` - through this box's EB, which carries it to
-- every other box (the "others" scope: never this one). A zone load ends a follow, so after each one it waits three
-- seconds for the boxes that came along to finish loading, and sends the line again.

local dist = tonumber((...))
local me = tostring(IS.Parse("${Me.Name}") or ""):gsub("[^%w']", "")
if me == "" then echo("eb_followme: start it in the world"); return end

local function callCrew(why)
    IS.Execute("luacall EBISX_cmd others follow " .. me .. (dist and (" " .. dist) or ""))
    echo("eb_followme: the crew follows " .. me .. " (" .. why .. ")")
end

local zoned = false
IS.AttachEvent("EQ2_FinishedZoning", function() zoned = true end)   -- only a flag: the loop acts

callCrew("start")
while true do
    if zoned then
        zoned = false
        wait(3)
        callCrew("after a zone load")
    end
    wait(0.5)
end
