-- Loop an instance once the group is ready (complete script)
--
-- A drop-in script for the tank's box: it waits until every member is in this zone, alive, healthy and rested, then types eb ic loop for you and ends. EB runs the loop: each run ends inside the cleared copy, the tank waits out the reset timer there, leaves by the exit, resets the copy from outside and goes back in.
--
-- kind:      complete script
-- file:      InnerSpace/Scripts/eb_icloop.lua
-- run:       lua eb_icloop fixture_hollow 120
--            endlua eb_icloop
--            eb ic stop
-- needs:     EB running on every box of the group; start this on the tank's box (the box that types the loop leads it)
--            the instance installed (the complete instance file fixture_hollow and its encounters)
--            every box already in the hub zone (fixture_docks)
-- expect:    It waits while a member is hurt, starts eb ic loop fixture_hollow 120 the moment the group is ready, and ends; the loop then runs two laps with the reset wait inside the copy.
-- verified:  on the offline stand-in for the game
-- id:        script-ic-loop-task

-- eb_icloop.lua - start an instance loop when the group is ready: everyone in this zone, alive, health at least 90%
-- and power at least 50%. Then it types `eb ic loop <instance> <minutes>` for you (through EB's console word) and
-- ends. EB runs the loop; `eb ic stop` ends it.
--
--   lua eb_icloop fixture_hollow 120      the instance's short name and the loop's minutes (0 = until eb ic stop)
--   endlua eb_icloop                      stop waiting, before the loop has started

local zone, minutes = ...
zone = tostring(zone or ""):gsub("[^%w_/%-]", "")         -- an instance name: letters, digits, _ - /
if zone == "" then
    echo("usage: lua eb_icloop <instance> [minutes]")
    return
end
minutes = math.max(0, math.floor(tonumber(minutes) or 0))
local MIN_HEALTH, MIN_POWER = 90, 50

local function split(s)
    local out = {}
    for v in (tostring(s or "") .. "|"):gmatch("(.-)|") do out[#out + 1] = v end
    return out
end

-- one read: me, then the other five group slots (Me.Group[1] .. [5]; an empty slot reads NULL)
local function groupReady()
    local seq = { "${Me.IsDead}", "${Me.Health}", "${Me.Power}", "${Me.GroupCount}" }
    for slot = 1, 5 do
        local g = "Me.Group[" .. slot .. "]"
        seq[#seq + 1] = "${" .. g .. ".Name}|${" .. g .. ".InZone}|${" .. g .. ".IsDead}|${" .. g .. ".Health}|${" ..
            g .. ".CurrentPower}|${" .. g .. ".MaxPower}"
    end
    local s = split(IS.Parse(table.concat(seq, "|")))
    if s[1] == "TRUE" then return false, "you are dead" end
    if (tonumber(s[2]) or 0) < MIN_HEALTH then return false, "you are hurt" end
    if (tonumber(s[3]) or 0) < MIN_POWER then return false, "you are low on power" end
    for slot = 1, math.min(5, (tonumber(s[4]) or 1) - 1) do
        local at = 5 + (slot - 1) * 6
        local name, inZone, dead = s[at], s[at + 1], s[at + 2]
        local hp, pw, maxPw = tonumber(s[at + 3]) or 0, tonumber(s[at + 4]) or 0, tonumber(s[at + 5]) or 0
        if inZone ~= "TRUE" then return false, name .. " is not in this zone" end
        if dead == "TRUE" then return false, name .. " is dead" end
        if hp < MIN_HEALTH then return false, name .. " is hurt" end
        if maxPw > 0 and pw * 100 / maxPw < MIN_POWER then return false, name .. " is low on power" end
    end
    return true
end

echo(("eb_icloop: waiting for the group to be ready for %s"):format(zone))
local said
while true do
    local ok, why = groupReady()
    if ok then break end
    if why ~= said then echo("eb_icloop: not yet - " .. why); said = why end
    wait(2)
end
IS.Execute("luacall EBISX_cmd ic loop " .. zone .. " " .. minutes)
echo(("eb_icloop: the group is ready - started eb ic loop %s %d (eb ic stop ends it)"):format(zone, minutes))
