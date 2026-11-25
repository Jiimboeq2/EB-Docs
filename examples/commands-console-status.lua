-- EB tested example: Type an eb command
-- commands-console-status | snippet | topics: commands, helpers
--
-- What it does:  Boot EB for InnerSpace offline and run console lines through the one command registry.
-- Tested:        eb status crew answers with this box's crew line; a word that is not a command is refused plainly.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: the whole of EB for InnerSpace booted by its real boot (in game you type in the console)
local a = DOCS.app()

-- your script: lines exactly as you type them in the InnerSpace console
local said = a.console("eb status crew")
print(said)
local refused = a.console("eb dance")

-- check
DOCS.has(said, "crew: box is1", "eb status crew names this box")
DOCS.has(refused, "refused", "a word that is not a command is refused")
a.stop()
DOCS.check(a.said("EB stopped"), "eb stop ends EB")
