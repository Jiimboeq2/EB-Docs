-- EB tested example: React to a boss emote
-- fight-emote-cue | snippet | topics: fights, events, helpers
--
-- What it does:  The pattern every fight script uses: an event handler only records the cue; a pulse task acts on it, because
--                acting may wait and a handler must not.
-- Tested:        The emote is recorded by the handler and acted on by the task one pulse later; other text is ignored.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.events()                                    -- EB's boot attaches the game's events and ticks them every frame

-- your script
local events = require("eb.events")
local pulse = require("eb.platform").pulse()
local CUES = { ["calls for its kin"] = "kill the adds", ["shudders violently"] = "spread out" }
local cues, done = {}, {}

events.on("IncomingText", function(ev)        -- runs inside the frame: record, never wait
    for text, what in pairs(CUES) do
        if ev.text:find(text, 1, true) then cues[#cues + 1] = what end
    end
end)
pulse.spawn("cue worker", function()           -- a task: free to wait (eb.delay) while it acts
    while #done < 1 do
        local what = table.remove(cues, 1)
        if what then print("acting on: " .. what); done[#done + 1] = what end
        eb.delay(100)
    end
end)

w.host:emitText("A fixture wolf howls.", 0)                          -- nothing to do with the fight
w.host:emitText("The Ashen Overseer shudders violently!", 0)         -- the cue
w.runFor(500)

-- check
DOCS.eq(#done, 1, "one cue acted on")
DOCS.eq(done[1], "spread out", "the right one")
DOCS.eq(#cues, 0, "nothing left waiting")
