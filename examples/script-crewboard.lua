-- Crew status board (complete script)
--
-- A drop-in script that listens to every EB box's status, prints a board of the crew, and pauses the crew when a box goes quiet (its EB stopped or its game closed) - then resumes when it is back.
--
-- kind:      complete script
-- file:      InnerSpace/Scripts/eb_crewboard.lua
-- run:       lua eb_crewboard 15
--            endlua eb_crewboard
-- needs:     EB for InnerSpace installed (the script finds EB through Scripts/EBIS/boot.json, as EB's own start does)
--            EB running on this box and on the crew's boxes (each box says its status every two seconds)
-- expect:    Lists each box with its zone, mode, health and power; pauses the crew when one goes quiet and resumes on its return.
-- verified:  on the offline stand-in for the game
-- modules:   eb.relay.wire
-- id:        script-crewboard

-- eb_crewboard.lua - the crew at a glance, and a pause when a box goes quiet.
--
--   lua eb_crewboard [seconds]     start it: how long a box may stay quiet before the crew pauses (default 15)
--   endlua eb_crewboard            stop it
--
-- Every EB box says who and where it is every two seconds, on the InnerSpace relay, as the event EBISX_State2 (at most
-- 40 arguments: the status's fields from the 40th on ride packed in the 40th, which this board never reads. Never attach
-- EB's old EBISX_State: an older EB sends it with 47 arguments, and ISXLUA hands a handler at most 42 safely). This
-- script finds the EB install the way EB's own start does (InnerSpace/Scripts/EBIS/boot.json,
-- read with ISXLUA's bundled cjson), loads EB's relay wire library from it, and decodes each status with
-- wire.decodeState. The event handler only queues; the main loop decodes, prints the board every ten seconds, and sends
-- `eb all pause` when a box that was heard stops talking for longer than the limit - and `eb all resume` once every box
-- is back.

local QUIET = tonumber((...)) or 15

-- EB's install, from the file EB Setup writes beside EB's start script
local home = tostring(IS.Parse("${LavishScript.HomeDirectory}") or ""):gsub("\\", "/"):gsub("/+$", "")
local f = io.open(home .. "/Scripts/EBIS/boot.json", "rb")
if not f then echo("eb_crewboard: EB for InnerSpace is not installed (no Scripts/EBIS/boot.json)"); return end
local text = f:read("a")
f:close()
local cjson = require("cjson.safe")
local boot = cjson.decode(text or "")
if type(boot) ~= "table" or type(boot.root) ~= "string" or boot.root == "" then
    echo("eb_crewboard: boot.json has no EB folder in it - run EB Setup again")
    return
end
local root = boot.root:gsub("\\", "/"):gsub("/+$", "")
package.path = root .. "/lua/?.lua;" .. root .. "/lua/?/init.lua;" .. package.path
local wire = require("eb.relay.wire")           -- EB's pure relay wire: no game reads, safe beside EB

local queue = {}
IS.AttachEvent("EBISX_State2", function(...) queue[#queue + 1] = { ... } end)

local socket = require("socket")
local boxes = {}                -- box id -> { st = decoded status, heard = seconds }
local paused, lastBoard = false, 0

local function board(now)
    local ids = {}
    for id in pairs(boxes) do ids[#ids + 1] = id end
    table.sort(ids)
    echo(("eb_crewboard: %d box(es)"):format(#ids))
    for _, id in ipairs(ids) do
        local b = boxes[id]
        echo(("  %-6s %-14s %-22s %-10s hp %3s  pw %3s%s%s"):format(id, b.st.name, b.st.zone, b.st.mode,
            tostring(b.st.hp or "?"), tostring(b.st.pw or "?"), b.st.combat and "  FIGHTING" or "",
            (now - b.heard > QUIET) and "  QUIET" or ""))
    end
end

echo(("eb_crewboard: listening to the crew (quiet after %d s pauses it) - endlua eb_crewboard stops it"):format(QUIET))
while true do
    local now = socket.gettime()
    if #queue > 0 then
        local got = queue
        queue = {}
        for _, args in ipairs(got) do
            local st = wire.decodeState(args)
            if st.box ~= "" then boxes[st.box] = { st = st, heard = now } end
        end
    end
    local quiet = {}
    for id, b in pairs(boxes) do if now - b.heard > QUIET then quiet[#quiet + 1] = id end end
    if #quiet > 0 and not paused then
        table.sort(quiet)
        IS.Execute("luacall EBISX_cmd all pause")
        echo("eb_crewboard: no word from " .. table.concat(quiet, ", ") .. " - the crew pauses")
        paused = true
    elseif #quiet == 0 and paused then
        IS.Execute("luacall EBISX_cmd all resume")
        echo("eb_crewboard: every box is back - the crew resumes")
        paused = false
    end
    if now - lastBoard >= 10 then board(now); lastBoard = now end
    wait(0.5)
end
