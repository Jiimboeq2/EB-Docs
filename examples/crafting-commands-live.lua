-- EB tested example: Which crafting, harvest and gear commands are live on this box
-- crafting-commands-live | snippet | topics: items, commands
--
-- What it does:  reg:unattached{ domain } lists the declared commands nobody answers yet on this box. On a box with the economy
--                installed (EB for InnerSpace's boot does that) the crafting, harvest and gear commands are all attached: each
--                typed line answers - a chore under way, a refusal in words, or a status line.
-- Tested:        No craft, harvest or gear command is left waiting, and typing each of nineteen of them answers in words (never
--                "not wired yet").
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: the whole of EB for InnerSpace booted by its real boot (in game you type in the console)
local a = DOCS.app()
local reg = a.app.reg

-- your script
local n = {}
for _, d in ipairs({ "craft", "harvest", "gear" }) do n[d] = #reg:unattached({ domain = d }) end
print(("craft %d, harvest %d, gear %d waiting"):format(n.craft, n.harvest, n.gear))
local lines = { "eb craft", "eb craftqueue status", "eb craftsetup", "eb recipebooks list", "eb tinker on",
    "eb writs craft", "eb luck on", "eb harvest status", "eb shinies status", "eb mats list", "eb gatherroute",
    "eb gearup self", "eb aup self", "eb adorn missing", "eb tempadorn on", "eb bestgear status", "eb gearjob",
    "eb glance", "eb transmutelevel status" }
local answered = 0
for _, line in ipairs(lines) do
    local text = a.console(line)
    if text:find("[eb", 1, true) and not text:find("does not answer on this box yet", 1, true) then answered = answered + 1 end
end

-- check
DOCS.eq(n.craft + n.harvest + n.gear, 0, "all 19 are attached: none waits")
DOCS.eq(#lines, 19, "nineteen of them are typed here")
DOCS.eq(answered, #lines, "each typed command answers in words, none says it is not wired yet")
a.stop()
