-- EB tested example: Say when a named spawns (complete script)
-- script-namedwatch | complete script | topics: helpers, crew, events
--
-- What it does:  A drop-in script that looks for named mobs around you every second and says each new one in group chat once;
--                with the word pause it also pauses the crew so nobody pulls into it.
-- Where it goes: InnerSpace/Scripts/eb_namedwatch.lua (save it as eb_namedwatch.lua)
-- Run it:        lua eb_namedwatch 120 pause
--                endlua eb_namedwatch
-- Needs:         - EB for InnerSpace running in this session (eb status answers) when you add the word pause
--                - nothing else: it reads the world around you and talks in group chat
-- Tested:        Announces a named once per spawn, pauses the crew the first time, and announces it again after a respawn.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- eb_namedwatch.lua - say when a named spawns.
--
--   lua eb_namedwatch [radius] [pause]     start it: how far to look (metres, default 100), and "pause" to pause
--                                          the crew (eb all pause) the first time a named shows up
--   endlua eb_namedwatch                   stop it (a pause it sent stays until you type eb all resume)
--
-- Every second ONE query fills the script's own LavishScript index (EBH_Named: never a game object's name) with the
-- named mobs in range, nearest first, and ONE read takes their ids, names and distances. Each id is announced once;
-- an id that is gone is forgotten, so the same named spawning again is announced again.

local radius = tonumber((...)) or 100
local pauseCrew = tostring(select(2, ...) or ""):lower() == "pause"
local VAR = "EBH_Named"

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

-- chat text: no LavishScript sequences, no line breaks
local function clean(s) return (tostring(s):gsub("%${", ""):gsub("[\r\n]", " ")) end

IS.Execute("squelch declarevariable " .. VAR .. " index:actor global")

local function nameds()
    IS.Execute(VAR .. ":Clear")
    -- the tested form: strings compared with ==, flags with = TRUE / = FALSE
    IS.Execute("EQ2:QueryActors[" .. VAR .. ", Type == \"NamedNPC\" && IsDead = FALSE && Distance <= " .. radius
        .. ", \"ByDist\"]")
    local n = math.min(tonumber(IS.Parse("${" .. VAR .. ".Used}")) or 0, 10)
    local rows = {}
    if n <= 0 then return rows end
    local seq = {}
    for i = 1, n do
        seq[#seq + 1] = "${" .. VAR .. "[" .. i .. "].ID}" .. SEP .. "${" .. VAR .. "[" .. i .. "].Name}" .. SEP ..
            "${" .. VAR .. "[" .. i .. "].Distance}"
    end
    local s = split(IS.Parse(table.concat(seq, SEP)))
    for i = 1, n do
        local id = tonumber(s[3 * i - 2]) or 0
        if id > 0 then rows[#rows + 1] = { id = id, name = s[3 * i - 1], distance = tonumber(s[3 * i]) or 0 } end
    end
    return rows
end

echo(("eb_namedwatch: watching %d m for named mobs%s - endlua eb_namedwatch stops it"):format(radius,
    pauseCrew and " (the crew pauses on the first)" or ""))
local seen, paused = {}, false
while true do
    local now = {}
    for _, r in ipairs(nameds()) do
        now[r.id] = true
        if not seen[r.id] then
            local line = ("Named up: %s (%d m)"):format(r.name, math.floor(r.distance + 0.5))
            IS.Execute("eq2execute gsay " .. clean(line))
            echo("eb_namedwatch: " .. line)
            if pauseCrew and not paused then
                IS.Execute("luacall EBISX_cmd all pause")
                paused = true
            end
        end
    end
    seen = now
    wait(1)
end
