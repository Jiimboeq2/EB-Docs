-- EB tested example: Send a command to one box, announce to all
-- crew-announce-and-send | snippet | topics: crew, commands
--
-- What it does:  The crew word in front of a command sends it: eb to is2 resume goes to box is2 only (not run here), and eb
--                announce shows one line on every box.
-- Tested:        The to-line leaves on the crew relay for is2 and is not run here; the announce is answered here.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
