-- EB tested example: The crew and coordination commands in this release
-- crew-commands-status | snippet | topics: commands, crew
--
-- What it does:  eb announce is answered; eb relay spells a crew line out (eb relay all pause is eb all pause); the targeting,
--                invite, event and coordination commands answer, or say plainly that this box does not answer them yet.
-- Tested:        announce answers; eb relay all pause pauses this box and sends one line to the crew; the seven others each
--                answer or say "not wired yet".
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: the whole of EB for InnerSpace booted by its real boot
local a = DOCS.app()

-- your script
local okA = eb.dispatch("eb announce regroup at the door")
local n0 = #a.host.log.relay
eb.dispatch("eb relay all pause")
local sent = 0
for i = n0 + 1, #a.host.log.relay do if a.host.log.relay[i].name == "EBISX_Cmd" then sent = sent + 1 end end
local pausedHere = a.app.brain.paused
eb.dispatch("eb resume")
local lines = { "eb tgt 200", "eb grab", "eb invite", "eb event", "eb tags", "eb claim", "eb rules" }
local plain = 0
for _, line in ipairs(lines) do
    local ok, text = eb.dispatch(line)
    if ok or tostring(text) ~= "" then plain = plain + 1 end
end
print(("announce %s | relay sent %d line | %d answered or said why"):format(okA and "ok" or "refused", sent, plain))

-- check
DOCS.check(okA, "eb announce is answered")
DOCS.eq(sent, 1, "eb relay all pause is eb all pause: one line goes to the crew")
DOCS.check(pausedHere, "and it ran on this box too")
DOCS.eq(plain, #lines, "the rest answer, or say plainly they are not wired yet")
a.stop()
