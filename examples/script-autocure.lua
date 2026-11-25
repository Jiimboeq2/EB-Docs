-- EB tested example: Auto-cure watcher (complete script)
-- script-autocure | complete script | topics: helpers, recipes, combat
--
-- What it does:  A drop-in script that keeps your group clear of one kind of detriment: when a member in this zone carries it,
--                target them, cast your cure, then go back to the target you had.
-- Where it goes: InnerSpace/Scripts/eb_autocure.lua (save it as eb_autocure.lua)
-- Run it:        lua eb_autocure "Cure Noxious" noxious
--                endlua eb_autocure
-- Needs:         - EB for InnerSpace's session (ISXEQ2 and ISXLUA loaded); EB itself does not have to run
--                - a cure ability in your knowledge book, by its exact name
--                - your cast stack's own cures turned off, so the two do not cast over each other
-- Tested:        Casts the cure once at the member who carries the detriment, then targets the mob it had before.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- eb_autocure.lua - keep your group clear of one kind of detriment. When a member in this zone carries it, target
-- them, cast your cure, then go back to the target you had. It reads only members EB has verified to work.
--
--   lua eb_autocure "Cure Noxious" noxious      start it (InnerSpace console): the ability, then the detriment kind
--   endlua eb_autocure                          stop it
--
-- Kinds: arcane, noxious, elemental, trauma. The whole group is read in ONE read four times a second; a cure is cast
-- only when it is ready, you are alive and you are not casting already.

local ability, kind = ...
kind = tostring(kind or "noxious"):lower()
local KINDS = { arcane = "Arcane", noxious = "Noxious", elemental = "Elemental", trauma = "Trauma" }
if not ability or not KINDS[kind] then
    echo('usage: lua eb_autocure "<cure ability>" arcane|noxious|elemental|trauma')
    return
end
local MEMBER = KINDS[kind]
local CHECK_EVERY = 0.25        -- seconds between checks (ISXLUA's wait takes seconds)

local function split(s)
    local out = {}
    for v in (tostring(s or "") .. "|"):gmatch("(.-)|") do out[#out + 1] = v end
    return out
end

-- one read: whether I can cast, my target, my own id and detriment count, then every other group slot's id,
-- in-zone, dead and detriment count (Me.Group[1] .. [5]; slot 0 would be you, read through Me instead)
local function snapshot()
    local seq = { "${Me.IsDead}", "${Me.CastingSpell}", '${Me.Ability["' .. ability .. '"].IsReady}', "${Target.ID}",
                  "${Me.ID}|TRUE|FALSE|${Me." .. MEMBER .. "}" }
    for slot = 1, 5 do
        local g = "Me.Group[" .. slot .. "]"
        seq[#seq + 1] = "${" .. g .. ".ID}|${" .. g .. ".InZone}|${" .. g .. ".IsDead}|${" .. g .. "." .. MEMBER .. "}"
    end
    return split(IS.Parse(table.concat(seq, "|")))
end

-- the first one in this zone, alive, who carries the detriment: you first, then the group
local function whoNeedsIt(s)
    for slot = 0, 5 do
        local at = 5 + slot * 4
        local id, inZone, dead, count = tonumber(s[at]) or 0, s[at + 1], s[at + 2], tonumber(s[at + 3]) or 0
        if id > 0 and inZone == "TRUE" and dead ~= "TRUE" and count > 0 then return id end
    end
    return nil
end

local function targetId() return tonumber(IS.Parse("${Target.ID}")) or 0 end

echo(("eb_autocure: curing %s with %s - endlua eb_autocure stops it"):format(kind, ability))
while true do
    local s = snapshot()
    if s[1] ~= "TRUE" and s[2] ~= "TRUE" and s[3] == "TRUE" then
        local id = whoNeedsIt(s)
        if id then
            local before = tonumber(s[4]) or 0
            IS.Execute("Actor[id," .. id .. "]:DoTarget")
            if waituntil(function() return targetId() == id end, 1) then
                IS.Execute('Me.Ability["' .. ability .. '"]:Use')
                echo("eb_autocure: " .. ability .. " on actor " .. id)
                wait(0.5)
                waituntil(function() return IS.Parse("${Me.CastingSpell}") ~= "TRUE" end, 5)
            end
            if before > 0 and before ~= id then IS.Execute("Actor[id," .. before .. "]:DoTarget") end
        end
    end
    wait(CHECK_EVERY)
end
