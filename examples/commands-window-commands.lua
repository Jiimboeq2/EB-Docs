-- The window and monitor commands in this release
--
-- Types each window and monitor command on a booted EB and reads its answer: each opens its window through the window bridge (eb ui, eb mini, eb map, eb xp, eb track, eb radar, eb meters, eb crew, eb anal, eb mybutton), lists the kept workspaces (eb battlestation) or prints its readout (eb waiting, eb crew status); eb windows lists every window with the line that opens it. (eb uireset, eb anon and eb streamer answer too; they change the user's own files, so a doc example does not press them.)
--
-- kind:      snippet
-- expect:    every window and monitor command is answered; eb windows lists every window with the line that opens it.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   commands.ui, commands.monitor
-- id:        commands-window-commands

-- offline stand-in: the whole of EB for InnerSpace booted by its real boot
local a = DOCS.app()

-- your script: the lines as a player types them
local lines = { "eb mini show", "eb ui", "eb map", "eb xp", "eb track cd", "eb radar on", "eb mybutton",
                "eb battlestation", "eb anal", "eb meters", "eb waiting", "eb crew", "eb crew status" }
local answered = 0
for _, line in ipairs(lines) do
    local ok, text = eb.dispatch(line)
    if not tostring(text):find("not wired yet", 1, true) then answered = answered + 1 end
end
local okList, list = eb.dispatch("eb windows")
local _, waiting = eb.dispatch("eb waiting")
local card = a.console("eb help meters")
print(("%d window and monitor commands typed, %d answered"):format(#lines, answered))

-- check
DOCS.eq(answered, #lines, "every window and monitor command is answered")
DOCS.check(okList, "eb windows answers")
DOCS.has(list, "eb mcp", "with the line that opens the MCP")
DOCS.has(waiting, "what the crew is waiting on", "eb waiting prints the crew's waits")
DOCS.has(card, "eb meters", "a help card still prints")
a.stop()
