-- Group-ready checker (complete script)
--
-- A drop-in script for after a fight or before a pull: it waits until everyone in the group is in this zone, alive, topped up and close, says so in group chat, and resumes the paused crew.
--
-- kind:      complete script
-- file:      InnerSpace/Scripts/eb_groupready.lua
-- run:       eb all pause
--            lua eb_groupready 90 80 30
-- needs:     EB for InnerSpace running in this session (eb status answers)
--            the crew paused first (eb all pause), so it waits for the go this script gives
-- expect:    Waits while a member is low or away, then says the group is ready once and the crew resumes.
-- verified:  on the offline stand-in for the game
-- id:        script-groupready

-- eb_groupready.lua - wait until the group is ready, then resume the crew.
--
--   eb all pause                                 pause the crew first (in the console)
--   lua eb_groupready [health] [power] [metres] [minutes]
--                                                start it: the lowest health and power in percent (default 90 and 80),
--                                                how close everyone must be (default 30 m), and how long to wait at
--                                                most (default 10 minutes). It ends by itself.
--
-- Twice a second ONE read takes you and every group slot: name, in this zone, dead, health, power, distance. Ready
-- twice in a row (no one just dipped below) -> one line in group chat and `eb all resume`. Out of time -> it says
-- who is not ready and ends without resuming.

local HEALTH = tonumber((...)) or 90
local POWER = tonumber((select(2, ...))) or 80
local NEAR = tonumber((select(3, ...))) or 30
local MINUTES = tonumber((select(4, ...))) or 10

local SEP = "~^~"
local function split(s)
    local out, i = {}, 1
    s = tostring(s or "")
    while true do
        local j = s:find(SEP, i, true)
        if not j then out[#out + 1] = s:sub(i); return out end
        out[#out + 1] = s:sub(i, j - 1)
        i = j + #SEP
    end
end

-- one read: me, then each other slot -> the list of reasons the group is not ready (empty = ready)
local FIELDS = { "Name", "InZone", "IsDead", "Health", "CurrentPower", "MaxPower", "Distance" }
local function notReady()
    local seq = { "${Me.IsDead}", "${Me.IsHated}", "${Me.Health}", "${Me.Power}" }
    for slot = 1, 5 do
        for _, f in ipairs(FIELDS) do seq[#seq + 1] = "${Me.Group[" .. slot .. "]." .. f .. "}" end
    end
    local s = split(IS.Parse(table.concat(seq, SEP)))
    local why = {}
    if s[1] == "TRUE" then why[#why + 1] = "you are dead" end
    if s[2] == "TRUE" then why[#why + 1] = "a fight is on you" end
    if (tonumber(s[3]) or 0) < HEALTH then why[#why + 1] = "your health is " .. tostring(s[3]) .. "%" end
    if (tonumber(s[4]) or 0) < POWER then why[#why + 1] = "your power is " .. tostring(s[4]) .. "%" end
    for slot = 1, 5 do
        local at = 4 + (slot - 1) * #FIELDS
        local name = s[at + 1]
        if name and name ~= "" and name ~= "NULL" then
            local hp, pw, maxPw = tonumber(s[at + 4]) or 0, tonumber(s[at + 5]) or 0, tonumber(s[at + 6]) or 0
            local pwPct = maxPw > 0 and (pw * 100 / maxPw) or 100
            if s[at + 2] ~= "TRUE" then why[#why + 1] = name .. " is not in this zone"
            elseif s[at + 3] == "TRUE" then why[#why + 1] = name .. " is dead"
            elseif hp < HEALTH then why[#why + 1] = ("%s's health is %d%%"):format(name, hp)
            elseif pwPct < POWER then why[#why + 1] = ("%s's power is %d%%"):format(name, math.floor(pwPct))
            elseif (tonumber(s[at + 7]) or 9999) > NEAR then why[#why + 1] = name .. " is too far away" end
        end
    end
    return why
end

local socket = require("socket")
local deadline = socket.gettime() + MINUTES * 60
echo(("eb_groupready: waiting for health %d%%, power %d%%, everyone within %d m"):format(HEALTH, POWER, NEAR))
local streak, why = 0, {}
while socket.gettime() < deadline do
    why = notReady()
    streak = (#why == 0) and (streak + 1) or 0
    if streak >= 2 then
        IS.Execute("eq2execute gsay Group ready - moving on")
        IS.Execute("luacall EBISX_cmd all resume")
        echo("eb_groupready: the group is ready - the crew resumes")
        return
    end
    wait(0.5)
end
echo("eb_groupready: out of time, not resuming: " .. table.concat(why, "; "))
