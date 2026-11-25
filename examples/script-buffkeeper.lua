-- Buff keeper (complete script)
--
-- A drop-in script that keeps your own buffs up: when one of them is not maintained, is ready, and you are out of combat, standing still and not casting, it casts it.
--
-- kind:      complete script
-- file:      InnerSpace/Scripts/eb_buffkeeper.lua
-- run:       lua eb_buffkeeper "Fixture Ward" "Fixture Haste"
--            endlua eb_buffkeeper
-- needs:     EB for InnerSpace's session (ISXEQ2 and ISXLUA loaded); EB itself does not have to run
--            buffs you cast on yourself or on the whole group, named exactly as in your knowledge book
--            the same buffs left out of your cast stack, so the two do not cast over each other
-- expect:    Casts each missing buff once, waits while a fight is on, and casts a buff again after it drops.
-- verified:  on the offline stand-in for the game
-- id:        script-buffkeeper

-- eb_buffkeeper.lua - keep your own maintained buffs up.
--
--   lua eb_buffkeeper "Fixture Ward" "Fixture Haste"     start it (InnerSpace console): one or more buff names
--   endlua eb_buffkeeper                                 stop it
--
-- Once a second it reads, in ONE read, whether you can cast and whether each buff is ready, then (in a second read,
-- only when something is maintained) the names of your maintained spells. A missing, ready buff is cast when you are
-- alive, out of combat, standing still and not casting - one cast per check, so the next check sees the result.

local wanted = { ... }
if #wanted == 0 then
    echo('usage: lua eb_buffkeeper "<buff>" ["<buff>" ...]')
    return
end

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

-- "Fixture Ward II" and "Fixture Ward" are the same buff at another rank
local function base(name) return (tostring(name or ""):lower():gsub("%s+[ivxlc]+$", "")) end

-- one read: can I cast at all, how many spells I maintain, and whether each wanted buff is ready
local function state()
    local seq = { "${Me.IsDead}", "${Me.IsHated}", "${Me.CastingSpell}", "${Me.IsMoving}", "${Me.CountMaintained}" }
    for _, b in ipairs(wanted) do seq[#seq + 1] = '${Me.Ability["' .. b .. '"].IsReady}' end
    return split(IS.Parse(table.concat(seq, SEP)))
end

-- the names of what I maintain, by base name
local function maintained(count)
    local up = {}
    count = math.min(tonumber(count) or 0, 30)
    if count <= 0 then return up end
    local seq = {}
    for i = 1, count do seq[i] = "${Me.Maintained[" .. i .. "].Name}" end
    for _, name in ipairs(split(IS.Parse(table.concat(seq, SEP)))) do up[base(name)] = true end
    return up
end

-- say once which names are not in the book (they are skipped)
local known = {}
local check = {}
for i, b in ipairs(wanted) do check[i] = '${Me.Ability["' .. b .. '"](exists)}' end
for i, v in ipairs(split(IS.Parse(table.concat(check, SEP)))) do
    known[i] = (v == "TRUE")
    if not known[i] then echo("eb_buffkeeper: no ability called '" .. wanted[i] .. "' in your book - skipped") end
end

echo("eb_buffkeeper: keeping " .. table.concat(wanted, ", ") .. " up - endlua eb_buffkeeper stops it")
while true do
    local s = state()
    if s[1] ~= "TRUE" and s[2] ~= "TRUE" and s[3] ~= "TRUE" and s[4] ~= "TRUE" then
        local up = maintained(s[5])
        for i, b in ipairs(wanted) do
            if known[i] and not up[base(b)] and s[5 + i] == "TRUE" then
                IS.Execute('Me.Ability["' .. b .. '"]:Use')
                echo("eb_buffkeeper: cast " .. b)
                wait(0.5)
                waituntil(function() return IS.Parse("${Me.CastingSpell}") ~= "TRUE" end, 10)
                break
            end
        end
    end
    wait(1)
end
