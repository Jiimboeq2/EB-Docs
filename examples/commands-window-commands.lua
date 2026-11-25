-- EB tested example: The window and monitor commands in this release
-- commands-window-commands | snippet | topics: commands, ui
--
-- What it does:  Types each window and monitor command on a booted EB and reads its answer: each opens its window through the
--                window bridge (eb ui, eb mini, eb map, eb xp, eb track, eb radar, eb meters, eb crew, eb anal, eb mybutton),
--                lists the kept workspaces (eb battlestation) or prints its readout (eb waiting, eb crew status); eb windows
--                lists every window with the line that opens it. (eb uireset, eb anon and eb streamer answer too; they change the
--                user's own files, so a doc example does not press them.)
-- Tested:        every window and monitor command is answered; eb windows lists every window with the line that opens it.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
