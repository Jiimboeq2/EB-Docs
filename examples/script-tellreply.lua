-- EB tested example: Answer tells while you are away (complete script)
-- script-tellreply | complete script | topics: helpers, events
--
-- What it does:  A drop-in script that answers each player who sends you a tell with your away line, once per person per ten
--                minutes, and ignores group, raid, say and NPC lines.
-- Where it goes: InnerSpace/Scripts/eb_tellreply.lua (save it as eb_tellreply.lua)
-- Run it:        lua eb_tellreply "Away for a bit - back soon" 10
--                endlua eb_tellreply
-- Needs:         - EB for InnerSpace's session (ISXEQ2 and ISXLUA loaded); EB itself does not have to run
-- Tested:        Answers the first tell from each player once, stays quiet for repeats inside the window, and never answers an
--                NPC.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- eb_tellreply.lua - answer tells while you are away.
--
--   lua eb_tellreply "<your away line>" [minutes]    start it: the line to send, and how long before the same person
--                                                    gets it again (default 10 minutes)
--   endlua eb_tellreply                              stop it
--
-- The game's chat event only QUEUES each line (an event handler must not wait or read much); the main loop takes the
-- queue twice a second. A line is a tell to you when its target is your own name, it has no channel name and the
-- speaker is a player other than you - so group, raid, say and channel lines never get an answer.

local message, minutes = ...
if not message or message == "" then
    echo('usage: lua eb_tellreply "<your away line>" [minutes]')
    return
end
local EVERY = (tonumber(minutes) or 10) * 60

-- a tell's text and a name, made safe for one console line
local function cleanText(s) return (tostring(s):gsub("%${", ""):gsub("[\r\n]", " ")) end
local function cleanName(s) return (tostring(s):gsub("[^%w']", "")) end

local queue = {}
IS.AttachEvent("EQ2_onIncomingChatText", function(chatType, text, speaker, target, speakerIsNPC, channel)
    queue[#queue + 1] = { speaker = tostring(speaker or ""), target = tostring(target or ""),
                          npc = tostring(speakerIsNPC or ""):upper() == "TRUE", channel = tostring(channel or "") }
end)

local socket = require("socket")
local answered = {}            -- lower-case name -> when they were last answered (seconds)
echo("eb_tellreply: answering tells - endlua eb_tellreply stops it")
while true do
    if #queue > 0 then
        local lines = queue
        queue = {}
        local me = tostring(IS.Parse("${Me.Name}") or ""):lower()
        local now = socket.gettime()
        for _, l in ipairs(lines) do
            local who = l.speaker:lower()
            if not l.npc and l.channel == "" and me ~= "" and l.target:lower() == me and who ~= "" and who ~= me then
                if not answered[who] or now - answered[who] >= EVERY then
                    answered[who] = now
                    IS.Execute("eq2execute tell " .. cleanName(l.speaker) .. " " .. cleanText(message))
                    echo("eb_tellreply: answered " .. l.speaker)
                end
            end
        end
    end
    wait(0.5)
end
