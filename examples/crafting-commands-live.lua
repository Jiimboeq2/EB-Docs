-- Which crafting, harvest and gear commands are live on this box
--
-- reg:unattached{ domain } lists the declared commands nobody answers yet on this box. On a box with the economy installed (EB for InnerSpace's boot does that) the crafting, harvest and gear commands are all attached: each typed line answers - a chore under way, a refusal in words, or a status line.
--
-- kind:      snippet
-- expect:    No craft, harvest or gear command is left waiting, and typing each of nineteen of them answers in words (never "not wired yet").
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.registry, commands.craft, commands.harvest, commands.gear
-- id:        crafting-commands-live

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
