-- Tell me when a yes/no question waits (complete script)
--
-- A drop-in script that notices the game's yes/no windows (a revive offer, an invite, a trade question) and says what is asked, on the console and in group chat, so you can answer it - it never clicks one itself.
--
-- kind:      complete script
-- file:      InnerSpace/Scripts/eb_choicealert.lua
-- run:       lua eb_choicealert group
--            endlua eb_choicealert
-- needs:     EB for InnerSpace's session (ISXEQ2 and ISXLUA loaded); EB itself does not have to run
--            you, to answer the window: EB does not click yes/no windows on this release
-- expect:    Says the question and its two answers once per window and clicks nothing.
-- verified:  on the offline stand-in for the game
-- id:        script-choicealert

-- eb_choicealert.lua - say when a yes/no question is waiting for you.
--
--   lua eb_choicealert [group]     start it; with "group" the question also goes to group chat (your crew's
--                                  screens), else only to this console
--   endlua eb_choicealert          stop it
--
-- The game's event for a new choice window only QUEUES; the main loop then reads the window once - its text and its
-- two answers in ONE read - and says them. It answers nothing: clicking a yes/no window is not something EB does on
-- this release, so a person decides.

local toGroup = tostring((...) or ""):lower() == "group"

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
local function clean(s) return (tostring(s):gsub("%${", ""):gsub("[\r\n]", " ")) end

local pending = 0
IS.AttachEvent("EQ2_onChoiceWindowAppeared", function() pending = pending + 1 end)

echo("eb_choicealert: watching for yes/no windows - endlua eb_choicealert stops it")
while true do
    if pending > 0 then
        pending = 0
        local s = split(IS.Parse("${ChoiceWindow.IsVisible}" .. SEP .. "${ChoiceWindow.Text.GetProperty[LocalText]}" ..
            SEP .. "${ChoiceWindow.Choice1}" .. SEP .. "${ChoiceWindow.Choice2}"))
        if s[1] == "TRUE" then
            local line = ("Waiting for an answer: %s [%s / %s]"):format(s[2], s[3], s[4])
            echo("eb_choicealert: " .. line)
            if toGroup then IS.Execute("eq2execute gsay " .. clean(line)) end
        end
    end
    wait(0.25)
end
