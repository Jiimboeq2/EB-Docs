-- EB tested example: The item and loot commands in this build
-- econ-commands-status | snippet | topics: items, commands
--
-- What it does:  The loot, depot and broker commands are declared in EB's command schema, so eb help lists them and the console
--                completes them, and EB runs the economy behind them: eb bank status, eb loot status and eb broker status each
--                say how things stand. eb roster list names your characters from EB's own sources (never a login detail).
--                reg:unattached shows which commands a domain still waits for.
-- Tested:        eb help depot lists the commands; eb bank status, eb loot status and eb broker status answer with their state
--                and no depot command waits; eb roster list names the characters EB knows.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: the whole of EB for InnerSpace booted by its real boot (in game you type in the console)
local a = DOCS.app()

-- your script: lines exactly as you type them
local help = a.console("eb help depot")
local bank = a.console("eb bank status")
print(bank)
local loot, broker = a.console("eb loot status"), a.console("eb broker status")
local roster = a.console("eb roster list")
local waiting = a.app.reg:unattached({ domain = "depot" })

-- check
DOCS.has(help, "bank", "eb help depot lists the bank command")
DOCS.has(bank, "bank (personal)", "eb bank status says how the bank stands")
DOCS.has(loot, "loot as we go", "eb loot status says whether looting runs")
DOCS.has(broker, "broker: idle", "eb broker status says what the broker is doing")
DOCS.has(roster, "character(s)", "eb roster list names the characters EB knows")
DOCS.eq(#waiting, 0, "no depot command waits for the economy")
a.stop()
