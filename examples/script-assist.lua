-- Follow and assist the tank (complete script)
--
-- A drop-in script for a box in the crew: it asks EB to follow the tank, then keeps your target on the mob the tank is fighting, so your box's fight goes where the tank's does.
--
-- kind:      complete script
-- file:      InnerSpace/Scripts/eb_assist.lua
-- run:       lua eb_assist Tankard follow
--            endlua eb_assist
-- needs:     EB for InnerSpace running in this session (eb status answers) when you add the word follow
--            the tank in your group, named as the game shows it
--            a walk EB starts with follow ends when EB stops, or when another walk replaces it
-- expect:    EB answers the follow; the target moves to each mob the tank fights and never to one that is not fighting.
-- verified:  on the offline stand-in for the game
-- id:        script-assist

-- eb_assist.lua - follow the tank and fight what the tank fights.
--
--   lua eb_assist Tankard follow     start it: the tank's name, and "follow" to have EB walk after the tank
--   lua eb_assist Tankard            assist only (you walk, or something else moves you)
--   endlua eb_assist                 stop assisting (a follow EB started keeps going until EB stops or walks elsewhere)
--
-- Four times a second: ONE read finds the tank in your group and your own target; when the tank is there, a second
-- read takes the tank's target and what it is. Only a mob that is already fighting (an NPC or a named, alive, in
-- combat mode) becomes your target - the script never starts a fight and never picks anything the tank did not.

local tank, word = ...
if not tank or tank == "" then
    echo("usage: lua eb_assist <tank name> [follow]")
    return
end
local tankLow = tank:lower()

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

if tostring(word or ""):lower() == "follow" then
    IS.Execute("luacall EBISX_cmd follow " .. tank:gsub("[^%w']", ""))   -- EB walks after the tank over the mesh
end

-- one read: my target, then each other group slot's name and id
local function group()
    local seq = { "${Target.ID}" }
    for slot = 1, 5 do
        seq[#seq + 1] = "${Me.Group[" .. slot .. "].Name}"
        seq[#seq + 1] = "${Me.Group[" .. slot .. "].ID}"
    end
    local s = split(IS.Parse(table.concat(seq, SEP)))
    local tankId
    for slot = 1, 5 do
        if tostring(s[2 * slot]):lower() == tankLow then tankId = tonumber(s[2 * slot + 1]) end
    end
    return tonumber(s[1]) or 0, tankId
end

-- one read: what the tank targets - its id, type, dead flag and combat mode
local function tanksTarget(tankId)
    local t = "Actor[id," .. tankId .. "].Target"
    local s = split(IS.Parse("${" .. t .. ".ID}" .. SEP .. "${" .. t .. ".Type}" .. SEP .. "${" .. t .. ".IsDead}"
        .. SEP .. "${" .. t .. ".InCombatMode}"))
    return tonumber(s[1]) or 0, s[2], s[3] == "TRUE", s[4] == "TRUE"
end

echo("eb_assist: assisting " .. tank .. " - endlua eb_assist stops it")
local lastSaid
while true do
    local mine, tankId = group()
    if tankId and tankId > 0 then
        local mob, kind, dead, fighting = tanksTarget(tankId)
        if mob > 0 and mob ~= mine and (kind == "NPC" or kind == "NamedNPC") and not dead and fighting then
            IS.Execute("Actor[id," .. mob .. "]:DoTarget")
            if lastSaid ~= mob then echo("eb_assist: on " .. tank .. "'s target, actor " .. mob); lastSaid = mob end
        end
    end
    wait(0.25)
end
