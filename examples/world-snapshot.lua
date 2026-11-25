-- EB tested example: Read the world snapshot
-- world-snapshot | snippet | topics: game, perf, helpers
--
-- What it does:  eb.world builds ONE plain table per frame from the game layer: you, your state and your group.
-- Tested:        The snapshot has your name, class, archetype, zone, health and power, the fight flag and the group.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ pulse = false, me = { healthPct = 72, powerPct = 55, inCombat = true } })
w.addMember({ name = "Mendwell", id = 11, class = "templar", healthPct = 90, inZone = true })
w.addActor({ id = 11, name = "Mendwell", type = "PC", isNPC = false, distance = 7 })

-- your script
local game = require("eb.platform").game()
local world = require("eb.world").new({ game = game })
local snap = world.snapshot()
w.self.healthPct = 40                     -- the game moves on ...
local same = world.snapshot()             -- ... but inside one frame the snapshot is the same table
world.invalidate()                        -- rebuild the table (the game layer still answers this frame's reads)
local rebuilt = world.snapshot()
world.beginTick()                         -- a new frame: the game layer reads again, the snapshot is rebuilt
local fresh = world.snapshot()
print(("%s %s (%s) hp %d power %d fighting=%s group %d"):format(snap.name, snap.class, snap.archetype,
    snap.hpPct, snap.powerPct, tostring(snap.hated), snap.group.count))

-- check
DOCS.eq(snap.inGame, true, "in the world")
DOCS.eq(same, snap, "one snapshot per frame")
DOCS.check(rebuilt ~= snap and rebuilt.hpPct == 72, "invalidate builds a new table from this frame's reads")
DOCS.eq(fresh.hpPct, 40, "beginTick: the next snapshot reads the game again")
DOCS.eq(snap.archetype, "priest", "the archetype from the class")
DOCS.eq(snap.hated, true, "a fight is on (the hate flag, not the lingering in-combat flag)")
DOCS.eq(snap.group.members[1].name, "Mendwell", "the group member")
DOCS.eq(snap.group.members[1].role, "priest", "with the member's archetype")
DOCS.check(snap.reads <= 8 and not snap.partial, "inside the read budget")
