-- Event watcher (complete script)
--
-- A drop-in script that reacts to the game's own events the safe way: each handler only queues, and the main loop logs zoning, loot windows and incoming text - and pauses the crew when a line you name appears.
--
-- kind:      complete script
-- file:      InnerSpace/Scripts/eb_eventwatch.lua
-- run:       lua eb_eventwatch "The ground shakes"
--            endlua eb_eventwatch
-- needs:     EB for InnerSpace running in this session (eb status answers) for the crew pause
-- expect:    Logs the zone after a zone load, the loot window's items, and pauses the crew on the named text.
-- verified:  on the offline stand-in for the game
-- id:        script-eventwatch

-- eb_eventwatch.lua - react to the game's events: zoning, loot windows, incoming text.
--
--   lua eb_eventwatch ["<text>"]     start it; when a line of game text contains <text>, the crew pauses
--   endlua eb_eventwatch             stop it
--
-- THE PATTERN. An event handler runs inside the game's own callback: it must not wait and should not read the game.
-- Each handler here only puts a small record on a queue; the main loop takes the queue every frame and does the
-- work. The zone's name is read only after the load FINISHES - it already names the next zone while the load runs.
-- The loot window is read only after its event says one opened: reading it with no window up is slow.

local trigger = ...
trigger = trigger and trigger ~= "" and trigger:lower() or nil

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

local queue = {}
local function push(kind, a) queue[#queue + 1] = { kind = kind, a = a } end      -- the handlers do only this
IS.AttachEvent("EQ2_StartedZoning", function() push("zoning") end)
IS.AttachEvent("EQ2_FinishedZoning", function(seconds) push("zoned", seconds) end)
IS.AttachEvent("EQ2_onLootWindowAppeared", function(id) push("loot", id) end)
IS.AttachEvent("EQ2_onIncomingText", function(text) push("text", text) end)

local function onZoned(seconds)
    local s = split(IS.Parse("${Zone.Name}" .. SEP .. "${Zone.ShortName}"))
    echo(("eb_eventwatch: in %s (%s) after %s s"):format(s[1], s[2], tostring(seconds)))
end

local function onLoot()
    local n = math.min(tonumber(IS.Parse("${LootWindow.NumItems}")) or 0, 8)
    if n <= 0 then return end
    local seq = {}
    for i = 1, n do seq[i] = "${LootWindow.Item[" .. i .. "].Name}" end
    echo("eb_eventwatch: loot - " .. table.concat(split(IS.Parse(table.concat(seq, SEP))), ", "))
end

local function onText(text)
    if trigger and tostring(text):lower():find(trigger, 1, true) then
        IS.Execute("luacall EBISX_cmd all pause")
        echo("eb_eventwatch: '" .. tostring(text) .. "' - the crew pauses")
    end
end

echo("eb_eventwatch: watching zoning, loot and game text - endlua eb_eventwatch stops it")
while true do
    if #queue > 0 then
        local events = queue
        queue = {}
        for _, ev in ipairs(events) do
            if ev.kind == "zoning" then echo("eb_eventwatch: zoning...")
            elseif ev.kind == "zoned" then onZoned(ev.a)
            elseif ev.kind == "loot" then onLoot()
            elseif ev.kind == "text" then onText(ev.a) end
        end
    end
    waitframe()
end
