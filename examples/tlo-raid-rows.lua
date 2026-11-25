-- EB tested example: Read the raid outside your group
-- tlo-raid-rows | snippet | topics: tlos, crew
--
-- What it does:  game.Raid(myGroup, refreshSec) reads Me.Raid[n] for the raid members who are not in your own group, at most once
--                every refreshSec (default half a second).
-- Tested:        Lists the two raid members outside your group and leaves your own group member out.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.world.raid = {
    { name = "Tankfixture", id = 11, class = "guardian", healthPct = 80, inZone = true, raidGroupNum = 1 },
    { name = "Raidfixture", id = 21, class = "templar", healthPct = 95, inZone = true, raidGroupNum = 2 },
    { name = "Raiderfixture", id = 22, class = "ranger", healthPct = 40, inZone = true, raidGroupNum = 2 },
}
for _, m in ipairs(w.world.raid) do w.addActor({ id = m.id, name = m.name, type = "PC", isNPC = false, distance = 10 }) end

-- your script: pass your own group's names (lower case) so the raid list holds only the others
local game = require("eb.platform").game()
local rows = game.Raid({ tankfixture = true }, 0)
local parts = {}
for _, r in ipairs(rows) do parts[#parts + 1] = ("%s (%d%%)"):format(r.name, r.healthPct) end
print("raid: " .. table.concat(parts, ", "))

-- check
DOCS.eq(#rows, 2, "your own group is left out")
DOCS.eq(rows[2].healthPct, 40, "health in percent")
DOCS.eq(game.GetVar("Me.RaidCount", 0), 3, "Me.RaidCount counts the whole raid")
