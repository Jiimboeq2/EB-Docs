-- Read your group and find who is hurt
--
-- Group() answers the other members of your group (slots 1 to 5) in one batched read: health and power in percent, in the zone or not, distance, dead.
--
-- kind:      snippet
-- expect:    Finds the most hurt member in the zone and skips the one out of the zone.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-group-rows

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
