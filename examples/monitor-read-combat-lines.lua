-- EB tested example: Read combat lines into records
-- monitor-read-combat-lines | snippet | topics: combat, data
--
-- What it does:  combatlog.parse turns one line of combat text into a record - a hit, a damage-over-time tick, a heal, a ward, a
--                miss, a death - with YOU resolved to your own name; anything else is nil.
-- Tested:        Each combat line gives its kind, who, whom and how much; a chat line gives nil.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local log = require("eb.ui.monitor.combatlog")
local me = "Fixturae"
local lines = {
    "YOUR Fixture Flare hits a fixture brute for 1,200 points of heat damage.",
    "A fixture brute suffers 300 points of poison damage from Fixturae's Fixture Venom.",
    "Mendwell's Fixture Mend heals Tankard for 800 hit points (150).",
    "Mendwell wards YOU against 500 points of damage.",
    "A fixture brute tries to hit YOU, but YOU parry!",
    "You have slain a fixture brute!",
    "Tankard says, 'Pull the next one.'",
}
local recs, show = {}, {}
for i, line in ipairs(lines) do
    local r = log.parse(line, { me = me, t = i * 1000 })
    recs[i] = r
    if r then
        if r.kind == "hit" then show[#show + 1] = ("hit %d %s"):format(r.amount, r.dtype)
        elseif r.kind == "heal" then show[#show + 1] = ("heal %d (+%d over)"):format(r.amount, r.over)
        elseif r.kind == "ward" then show[#show + 1] = ("ward %d"):format(r.amount)
        elseif r.kind == "miss" then show[#show + 1] = "miss " .. r.avoid
        else show[#show + 1] = r.kind end
    end
end
print(table.concat(show, " | "))

-- check
DOCS.eq(recs[1].src, me, "YOUR is your own name")
DOCS.eq(recs[1].ability, "Fixture Flare", "the ability")
DOCS.eq(recs[2].src, me, "a damage-over-time tick credits its caster")
DOCS.eq(recs[3].dst, "Tankard", "the one healed")
DOCS.eq(recs[4].dst, me, "a ward on YOU")
DOCS.eq(recs[7], nil, "a chat line is not combat")
local all = log.parseAll(table.concat(lines, "\n"), { me = me, t0 = 0, stepMs = 1000 })
DOCS.eq(#all, 6, "parseAll keeps the six combat lines")
DOCS.eq(all[2].t, 1000, "and stamps them a step apart")
