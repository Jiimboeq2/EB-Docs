-- Hail and answer an NPC (complete script)
--
-- A drop-in script that hails your target and walks a conversation by the words of each reply you want, in the speech bubble or the classic conversation window, then ends.
--
-- kind:      complete script
-- file:      InnerSpace/Scripts/eb_hailreply.lua
-- run:       lua eb_hailreply "hollow" "help"
-- needs:     EB for InnerSpace's session (ISXEQ2 and ISXLUA loaded); EB itself does not have to run
--            the NPC targeted and close enough to hail
-- expect:    Hails, picks the reply containing each wanted word in turn (bubble and classic), and reports what it chose.
-- verified:  on the offline stand-in for the game
-- id:        script-hailreply

-- eb_hailreply.lua - hail your target and answer its conversation by words.
--
--   lua eb_hailreply "<words>" ["<words>" ...]    hail, then for each step pick the reply that contains <words>
--                                                 (case does not matter); it ends after the last step
--
-- An NPC talks in the speech bubble (read by its reply rows' text) or in the classic conversation window (its
-- replies listed into this script's own LavishScript index, EBH_Replies). Each step waits up to five seconds for the
-- conversation, clicks the matching reply, and waits for that reply to take. A step with no match lists the replies
-- it saw and stops - it never clicks a guess.

local wants = { ... }
if #wants == 0 then
    echo('usage: lua eb_hailreply "<words of the reply>" ["<words of the next reply>" ...]')
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

local BUBBLE = "EQ2UIPage[ProxyActor,Conversation].Child[composite,replies]"
local VAR = "EBH_Replies"
IS.Execute("squelch declarevariable " .. VAR .. " index:collection:string global")

-- the conversation as it stands: { kind = "bubble" | "classic", options = { texts } } or nil
local function conversation()
    local seq = {}
    for i = 1, 8 do
        seq[#seq + 1] = "${" .. BUBBLE .. ".Child[" .. i .. "].GetProperty[visible]}"
        seq[#seq + 1] = "${" .. BUBBLE .. ".Child[" .. i .. "].GetProperty[LocalText]}"
    end
    seq[#seq + 1] = "${ReplyDialog(exists)}"
    seq[#seq + 1] = "${ReplyDialog.IsVisible}"
    local s = split(IS.Parse(table.concat(seq, SEP)))
    local options = {}
    for i = 1, 8 do
        if s[2 * i - 1] ~= "TRUE" then break end
        options[i] = s[2 * i]
    end
    if #options > 0 then return { kind = "bubble", options = options } end
    if s[17] == "TRUE" and s[18] ~= "FALSE" then
        IS.Execute(VAR .. ":Clear")
        IS.Execute("ReplyDialog.Replies:GetOptions[" .. VAR .. "]")
        local n = math.min(tonumber(IS.Parse("${" .. VAR .. ".Used}")) or 0, 12)
        local rows = {}
        for i = 1, n do
            rows[#rows + 1] = "${" .. VAR .. "[" .. i .. "].FirstKey}" .. SEP .. "${" .. VAR .. "[" .. i .. "].CurrentValue}"
        end
        local r = n > 0 and split(IS.Parse(table.concat(rows, SEP))) or {}
        for i = 1, n do options[i] = r[2 * i] or "" end
        return { kind = "classic", options = options }
    end
    return nil
end

local function choose(c, n)
    if c.kind == "bubble" then IS.Execute(BUBBLE .. ".Child[" .. n .. "]:LeftClick")
    else IS.Execute("ReplyDialog:Choose[" .. n .. "]") end
end

if (tonumber(IS.Parse("${Target.ID}")) or 0) <= 0 then echo("eb_hailreply: target the NPC first"); return end
IS.Execute("eq2execute hail")
for step, want in ipairs(wants) do
    local c
    waituntil(function() c = conversation(); return c ~= nil end, 5)
    if not c then echo(("eb_hailreply: step %d - no conversation opened"):format(step)); return end
    local pick
    for i, text in ipairs(c.options) do
        if tostring(text):lower():find(want:lower(), 1, true) then pick = i; break end
    end
    if not pick then
        echo(("eb_hailreply: step %d - no reply with '%s' (replies: %s)"):format(step, want, table.concat(c.options, " / ")))
        return
    end
    local chosen = c.options[pick]
    choose(c, pick)
    echo(("eb_hailreply: step %d - %s"):format(step, chosen))
    -- the reply takes when the conversation closes or changes
    waituntil(function()
        local now = conversation()
        return now == nil or now.kind ~= c.kind or table.concat(now.options, SEP) ~= table.concat(c.options, SEP)
    end, 5)
end
echo("eb_hailreply: done")
