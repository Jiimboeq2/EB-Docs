-- Harvest the nodes in reach (complete script)
--
-- A drop-in script that harvests the nodes within reach whose names you list, nearest first: double-click, wait for the harvest to finish, again until the node is gone, then the next. It never walks.
--
-- kind:      complete script
-- file:      InnerSpace/Scripts/eb_harvest.lua
-- run:       lua eb_harvest "ore vein" "root cluster" reach=8
--            endlua eb_harvest
-- needs:     EB for InnerSpace's session (ISXEQ2 and ISXLUA loaded); EB itself does not have to run
--            you stand within reach of the nodes (the script never moves you)
--            words from the nodes' names (any part of the name, any case)
-- expect:    Empties the two listed nodes in reach, leaves the lever and the node out of reach alone, and stops trying a node that never goes away.
-- verified:  on the offline stand-in for the game
-- id:        script-harvest

-- eb_harvest.lua - harvest the nodes around you. Twice a second, when you are not fighting, casting or moving, it
-- asks the game for the interactable actors within reach (one query into this script's own index variable, then one
-- read of the rows), picks the nearest whose name holds one of your words, and double-clicks it. It waits for the
-- harvest to finish and goes again until the node is gone; a node still there after six tries is skipped.
--
--   lua eb_harvest "<part of a node name>" ["<part>" ...] [reach=<metres>]     start it (reach: default 8)
--   endlua eb_harvest                                                             stop it

local words, reach = {}, 8
for _, a in ipairs({ ... }) do
    local r = tostring(a):match("^reach=(%d+%.?%d*)$")
    if r then reach = tonumber(r) elseif a ~= "" then words[#words + 1] = tostring(a):lower() end
end
if #words == 0 then
    echo('usage: lua eb_harvest "<part of a node name>" ["<part>" ...] [reach=<metres>]')
    return
end

local VAR = "EBH_Nodes"          -- this script's own LavishScript index:actor (never named after a game object)
local MAX_TRIES = 6
IS.Execute("declarevariable " .. VAR .. " index:actor global")

local function split(s)
    local out = {}
    for v in (tostring(s or "") .. "|"):gmatch("(.-)|") do out[#out + 1] = v end
    return out
end

local function busy()
    local s = split(IS.Parse("${Me.IsHated}|${Me.CastingSpell}|${Me.IsMoving}"))
    return s[1] == "TRUE" or s[2] == "TRUE" or s[3] == "TRUE"
end

local function wanted(name)
    local low = tostring(name):lower()
    for _, w in ipairs(words) do if low:find(w, 1, true) then return true end end
    return false
end

-- the wanted nodes in reach, nearest first: one query, then one read of up to 20 rows
local function nodesInReach()
    IS.Execute(VAR .. ":Clear")
    IS.Execute("EQ2:QueryActors[" .. VAR .. ", Interactable && Distance <= " .. reach .. ", \"ByDist\"]")
    local used = math.min(tonumber(IS.Parse("${" .. VAR .. ".Used}")) or 0, 20)
    if used == 0 then return {} end
    local seq = {}
    for i = 1, used do seq[i] = "${" .. VAR .. "[" .. i .. "].ID}|${" .. VAR .. "[" .. i .. "].Name}" end
    local r = split(IS.Parse(table.concat(seq, "|")))
    local out = {}
    for i = 1, used do
        local id, name = tonumber(r[i * 2 - 1]), r[i * 2]
        if id and id > 0 and wanted(name) then out[#out + 1] = { id = id, name = name } end
    end
    return out
end

local tries, skipped = {}, {}
echo(("eb_harvest: harvesting %s within %s m - endlua eb_harvest stops it"):format(table.concat(words, ", "), reach))
while true do
    if not busy() then
        local pick
        for _, node in ipairs(nodesInReach()) do
            if not skipped[node.id] then pick = node; break end
        end
        if pick then
            tries[pick.id] = (tries[pick.id] or 0) + 1
            if tries[pick.id] > MAX_TRIES then
                skipped[pick.id] = true
                echo("eb_harvest: skipping " .. pick.name .. " - still there after " .. MAX_TRIES .. " tries")
            else
                IS.Execute("Actor[id," .. pick.id .. "]:DoubleClick")
                echo("eb_harvest: harvesting " .. pick.name)
                wait(1)                                                     -- the harvest starts
                waituntil(function() return IS.Parse("${Me.CastingSpell}") ~= "TRUE" end, 8)
            end
        end
    end
    wait(0.5)
end
