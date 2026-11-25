-- EB tested example: Take loot windows by your rules (complete script)
-- script-lootall | complete script | topics: loot, events, helpers
--
-- What it does:  A drop-in script that takes a loot window the moment the game opens one: free-for-all windows by default, never
--                a window holding an item on your leave list, and with an only= list just the windows that hold one of those.
-- Where it goes: InnerSpace/Scripts/eb_lootall.lua (save it as eb_lootall.lua)
-- Run it:        lua eb_lootall "leave=Cursed Fixture Idol"
--                endlua eb_lootall
-- Needs:         - EB for InnerSpace's session (ISXEQ2 and ISXLUA loaded); EB itself does not have to run
--                - EB's own looting off, so the two do not both act on one window
-- Tested:        Takes the free-for-all window, leaves the lottery window and the window holding a leave-list item open for you,
--                and says why for each.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- eb_lootall.lua - take loot windows by your rules. It does nothing until the game says a loot window opened (the
-- loot-window event; a loot window is never polled - with no window up that read is slow), then reads the window's
-- type and every item name in ONE read and decides:
--   * a window that is not free-for-all is left for you, unless you start it with the word all;
--   * a window holding an item from leave= is left for you (EB takes a window whole, so it never takes part of one);
--   * with only=, a window is taken only when it holds at least one of those items.
-- Lists are item names separated by ';' (any case).
--
--   lua eb_lootall [all] ["leave=<item>;<item>"] ["only=<item>;<item>"]      start it
--   endlua eb_lootall                                                          stop it

local takeAny, leave, only = false, {}, nil
for _, word in ipairs({ ... }) do
    local low = tostring(word):lower()
    if low == "all" then
        takeAny = true
    elseif low:sub(1, 6) == "leave=" then
        for n in low:sub(7):gmatch("[^;]+") do leave[n] = true end
    elseif low:sub(1, 5) == "only=" then
        only = only or {}
        for n in low:sub(6):gmatch("[^;]+") do only[n] = true end
    else
        echo('usage: lua eb_lootall [all] ["leave=<item>;<item>"] ["only=<item>;<item>"]')
        return
    end
end

local function split(s)
    local out = {}
    for v in (tostring(s or "") .. "|"):gmatch("(.-)|") do out[#out + 1] = v end
    return out
end

-- the event handler runs in one go inside the game's frame: it only counts, the loop below does the work
local opened = 0
IS.AttachEvent("EQ2_onLootWindowAppeared", function() opened = opened + 1 end)

-- why a window stays open, or nil to take it
local function verdict(kind, names)
    if not takeAny and kind ~= "Free For All" then return "a " .. kind .. " window" end
    local wanted = only == nil
    for _, n in ipairs(names) do
        local low = n:lower()
        if leave[low] then return "it holds " .. n end
        if only and only[low] then wanted = true end
    end
    if not wanted then return "nothing on the only= list" end
    return nil
end

local function handleWindow()
    local head = split(IS.Parse("${LootWindow(exists)}|${LootWindow.Type}|${LootWindow.NumItems}"))
    if head[1] ~= "TRUE" then return end
    local kind, n = head[2], tonumber(head[3]) or 0
    local names = {}
    if n > 0 then
        local seq = {}
        for i = 1, n do seq[i] = "${LootWindow.Item[" .. i .. "].Name}" end
        names = split(IS.Parse(table.concat(seq, "|")))
    end
    local why = verdict(kind, names)
    if why then
        echo("eb_lootall: left the loot window open for you: " .. why)
    else
        IS.Execute("LootWindow:LootAll")
        echo(("eb_lootall: took %d item(s): %s"):format(n, table.concat(names, ", ")))
    end
end

echo("eb_lootall: waiting for loot windows - endlua eb_lootall stops it")
while true do
    if opened > 0 then
        opened = 0
        handleWindow()
    end
    waitframe()
end
