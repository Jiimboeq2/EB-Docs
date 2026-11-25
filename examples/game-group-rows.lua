-- EB tested example: Read your group and find who is hurt
-- game-group-rows | snippet | topics: game, crew, helpers
--
-- What it does:  Group() answers the other members of your group (slots 1 to 5) in one batched read: health and power in percent,
--                in the zone or not, distance, dead.
-- Tested:        Finds the most hurt member in the zone and skips the one out of the zone.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addMember({ name = "Tankfixture", id = 11, class = "guardian", healthPct = 72, powerPct = 60, inZone = true })
w.addMember({ name = "Mendfixture", id = 12, class = "templar", healthPct = 35, powerPct = 80, inZone = true })
w.addMember({ name = "Farfixture", id = 13, class = "wizard", healthPct = 10, powerPct = 90, inZone = false })
for _, m in ipairs(w.world.groupOthers) do
    if m.inZone then w.addActor({ id = m.id, name = m.name, type = "PC", isNPC = false, distance = 6 }) end
end

-- your script
local game = require("eb.platform").game()
local worst
for _, m in ipairs(game.Group()) do
    if m.inZone and not m.isDead and (not worst or m.healthPct < worst.healthPct) then worst = m end
end
if worst then print(("most hurt: %s at %d%%"):format(worst.name, worst.healthPct)) end

-- check
local rows = game.Group()
DOCS.eq(#rows, 3, "three other members")
DOCS.eq(worst.name, "Mendfixture", "the out-of-zone member is skipped")
DOCS.eq(rows[3].inZone, false, "out of the zone")
DOCS.eq(rows[3].distance, 9999, "an out-of-zone member reads 9999 m away")
