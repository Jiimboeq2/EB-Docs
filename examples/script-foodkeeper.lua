-- EB tested example: Food and drink keeper (complete script)
-- script-foodkeeper | complete script | topics: items, helpers
--
-- What it does:  A drop-in script that keeps auto-consume on for your food and drink slots and warns once when a stack gets low,
--                reading both slots in one read every five seconds.
-- Where it goes: InnerSpace/Scripts/eb_foodkeeper.lua (save it as eb_foodkeeper.lua)
-- Run it:        lua eb_foodkeeper 5
--                endlua eb_foodkeeper
-- Needs:         - EB for InnerSpace's session (ISXEQ2 and ISXLUA loaded); EB itself does not have to run
--                - food in your food slot and drink in your drink slot
-- Tested:        Turns auto-consume back on for the slot that had it off, and warns once (not every check) about the low stack.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- eb_foodkeeper.lua - keep eating and drinking. Every five seconds it reads your food and drink slots in ONE read: a
-- slot whose auto-consume is off gets it turned back on, and a stack at or under the low mark is called out once in
-- the console (again only after it was refilled and ran low again). It reads only members EB has verified to work.
--
--   lua eb_foodkeeper [low]      start it; low = warn at this many left (default 5)
--   endlua eb_foodkeeper         stop it

local low = tonumber((...)) or 5
local SLOTS = { "food", "drink" }
local CHECK_EVERY = 5               -- seconds (ISXLUA's wait takes seconds)
local warned = {}

local function split(s)
    local out = {}
    for v in (tostring(s or "") .. "|"):gmatch("(.-)|") do out[#out + 1] = v end
    return out
end

-- one read: each slot's item name, stack size and auto-consume switch
local function readSlots()
    local seq = {}
    for _, slot in ipairs(SLOTS) do
        local p = "Me.Equipment[" .. slot .. "]"
        seq[#seq + 1] = "${" .. p .. ".Name}|${" .. p .. ".Quantity}|${" .. p .. ".AutoConsumeOn}"
    end
    return split(IS.Parse(table.concat(seq, "|")))
end

local function sayOnce(key, text)
    if warned[key] then return end
    warned[key] = true
    echo("eb_foodkeeper: " .. text)
end

echo(("eb_foodkeeper: keeping food and drink on, warning at %d left - endlua eb_foodkeeper stops it"):format(low))
while true do
    local r = readSlots()
    for i, slot in ipairs(SLOTS) do
        local name, qty, on = r[i * 3 - 2], tonumber(r[i * 3 - 1]) or 0, r[i * 3]
        if name == nil or name == "" or name == "NULL" then
            sayOnce(slot .. ":empty", "nothing in your " .. slot .. " slot")
        else
            warned[slot .. ":empty"] = nil
            if on ~= "TRUE" then
                IS.Execute("Me.Equipment[" .. slot .. "]:ToggleAutoConsume")
                echo("eb_foodkeeper: auto-consume back on for " .. name)
            end
            if qty <= low then
                sayOnce(slot, ("%d %s left in your %s slot"):format(qty, name, slot))
            else
                warned[slot] = nil
            end
        end
    end
    wait(CHECK_EVERY)
end
