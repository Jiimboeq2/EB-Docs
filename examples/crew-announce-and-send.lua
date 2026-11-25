-- Send a command to one box, announce to all
--
-- The crew word in front of a command sends it: eb to is2 resume goes to box is2 only (not run here), and eb announce shows one line on every box.
--
-- kind:      snippet
-- expect:    The to-line leaves on the crew relay for is2 and is not run here; the announce is answered here.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   commands.relay, commands.core
-- id:        crew-announce-and-send

-- offline stand-in: the whole of EB for InnerSpace booted by its real boot (one box: is1)
local a = DOCS.app()

-- your script
a.console("eb pause")                                   -- this box pauses
local n0 = #a.host.log.relay
a.console("eb to is2 resume")                           -- only is2 resumes
local sent
for i = n0 + 1, #a.host.log.relay do
    local item = a.host.log.relay[i]
    if item.name == "EBISX_Cmd" then sent = item end    -- the crew line as it left this box
end
local ann = a.console("eb announce pulling now")
print(("sent to %s: %s | %s"):format(sent.args[5], sent.args[7], ann:match("announced: [^\n]*")))

-- check
DOCS.eq(sent.args[4], "to", "a to-line")
DOCS.eq(sent.args[7], "eb resume", "it carries the command without its crew word")
DOCS.check(a.app.brain.paused == true, "the line was not run on this box")
DOCS.has(ann, "announced: pulling now", "the announce")
a.stop()
