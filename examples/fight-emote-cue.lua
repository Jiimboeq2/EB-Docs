-- React to a boss emote
--
-- The pattern every fight script uses: an event handler only records the cue; a pulse task acts on it, because acting may wait and a handler must not.
--
-- kind:      snippet
-- expect:    The emote is recorded by the handler and acted on by the task one pulse later; other text is ignored.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.events, eb.platform
-- id:        fight-emote-cue

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
