-- EB tested example: Is it ready? Then cast it
-- combat-ready-and-cast | snippet | topics: combat, game
--
-- What it does:  Ask the game layer whether an ability is ready and how long until it is, then cast it at your target or on a
--                group member by name.
-- Tested:        Fixture Strike is ready and goes out at the target; Fixture Ward is 8 s away; Fixture Mend goes out on the
--                member by name.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Strike", "Fixture Ward", "Fixture Mend" })
FW.recast(w, "Fixture Ward", 8)
FW.mob(w, { id = 200, name = "a fixture brute" })
FW.target(w, 200)
w.addMember({ name = "Member1", id = 11, class = "guardian", healthPct = 55, powerPct = 80, inZone = true })

-- your script
local game = require("eb.platform").game()
if game.AbilityReady("Fixture Strike") then game.Cast("Fixture Strike") end     -- at your current target
print(("Fixture Ward ready in %d s"):format(game.AbilityTimeUntilReady("Fixture Ward")))
game.Cast("Fixture Mend", { name = "Member1" })                                -- on a player, by name

-- check
local casts = FW.casts(w)
DOCS.eq(casts[1], "Fixture Strike", "the ready ability went out")
DOCS.eq(w.world.casts[1].target, 200, "...at the target")
DOCS.eq(game.AbilityReady("Fixture Ward"), false, "the ward is not ready")
DOCS.eq(casts[2], "Fixture Mend", "the heal went out")
DOCS.eq(w.world.casts[2].target, "Member1", "...on the member by name")
