-- EB tested example: Read a group slot: Me.Group[n]
-- tlo-group-member | snippet | topics: tlos, crew
--
-- What it does:  Me.Group[0] is you and 1 to 5 are the others. A member in another zone reads ID 0 and has no distance, so check
--                InZone before acting on one.
-- Tested:        Reads both slots in one read and tells the member in the zone from the one away.
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
w.addMember({ name = "Farfixture", id = 13, class = "wizard", healthPct = 100, powerPct = 90, inZone = false })
w.addActor({ id = 11, name = "Tankfixture", type = "PC", isNPC = false, distance = 6 })

-- your script (the game layer's Group() reads all five slots like this, in one batch)
local raw = IS.Parse("${Me.GroupCount}|${Me.Group[1].Name}|${Me.Group[1].InZone}|${Me.Group[1].HitPoints}|" ..
    "${Me.Group[1].MaxHitPoints}|${Me.Group[2].Name}|${Me.Group[2].InZone}|${Me.Group[2].ID}")
local f = {}
for v in (raw .. "|"):gmatch("([^|]*)|") do f[#f + 1] = v end
print(("%s in zone %s/%s; %s %s"):format(f[2], f[4], f[5], f[6], f[7] == "TRUE" and "here" or "away"))

-- check
DOCS.eq(tonumber(f[1]), 3, "GroupCount counts you too")
DOCS.eq(f[3], "TRUE", "the tank is in the zone")
DOCS.eq(f[8], "0", "a member in another zone reads ID 0")
