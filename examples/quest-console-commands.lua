-- EB tested example: The quest commands from the console
-- quest-console-commands | snippet | topics: quests, commands
--
-- What it does:  Boot EB offline and type the quest commands the way you would in game. eb ql starts a quest line (or one quest)
--                by its name and runs it as EB's goal; eb pl runs a power-level route; eb queue lines them up; eb dialog reads
--                and answers what an NPC shows; eb timer leaves a reminder or runs a line later. With nothing running yet, each
--                one answers at once and says what it would do.
-- Tested:        eb ql status says no line is running, eb pl status no route, the queue is empty, no conversation is open, and eb
--                help quest lists the domain.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: the whole of EB for InnerSpace booted by its real boot
local a = DOCS.app()

-- your script: lines exactly as you type them
local ql = a.console("eb ql status")
local pl = a.console("eb pl status")
local queue = a.console("eb queue")
local dialog = a.console("eb dialog")
local timer = a.console("eb timer add tea 5m the tea is ready")
local help = a.console("eb help quest")
print(ql)
print(queue)

-- check
DOCS.has(ql, "ql: no quest line - eb ql start <line or quest>", "eb ql answers: no line is running yet")
DOCS.has(pl, "pl: no route running", "eb pl answers: no route is running")
DOCS.has(queue, "queue: stopped, 0 waiting", "the quest queue is empty")
DOCS.has(dialog, "dialog: no conversation is open", "eb dialog reads what an NPC shows: nothing now")
DOCS.has(timer, "timer #1 tea", "eb timer leaves a reminder")
DOCS.has(help, "ql", "eb help quest lists the quest commands")
a.stop()
