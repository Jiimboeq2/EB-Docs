-- EB tested example: Guards are never pulled or splashed
-- combat-never-a-guard | snippet | topics: combat, helpers
--
-- What it does:  Ask the combat plane whether a target is winnable before you pull: a guard is refused. With a guard standing in
--                AE reach of your fight, the engine skips its AE and casts a single-target art instead.
-- Tested:        isWinnable refuses the guard ("guard") and accepts the brute; the AE is vetoed while the guard is near, and the
--                single-target art goes out at the brute.
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
FW.book(w, { "Fixture Cleave", "Fixture Strike" })
FW.mob(w, { id = 200, name = "a fixture brute", distance = 6 })
w.addActor({ id = 210, name = "a fixture guard", type = "NPC", distance = 12 })   -- standing near, not in the fight
FW.target(w, 200)

-- your script
local game = require("eb.platform").game()
local P = require("eb.platform")
local combat = require("eb.app.combat").new({ game = game, clock = P.now })   -- what EB's start builds once per box
combat.holder.rebind({ entries = {
    { name = "Fixture Cleave", ability = "Fixture Cleave", group = "dps", tags = "AE", priority = 99, gates = {} },
    { name = "Fixture Strike", ability = "Fixture Strike", group = "dps", tags = "CA", priority = 97, gates = {} } } })

for _, name in ipairs({ "a fixture guard", "a fixture brute" }) do
    local ok, why = combat.facade.brain.isWinnable(name)      -- ask before any pull
    print(("%s: %s %s"):format(name, tostring(ok), tostring(why)))
end
local d = combat.engine:step()
print(("cast %s at %s"):format(tostring(d.ability), tostring(d.target)))

-- check
local okG, whyG = combat.facade.brain.isWinnable("a fixture guard")
DOCS.eq(okG, false, "a guard is never winnable")
DOCS.eq(whyG, "guard", "and the reason says so")
DOCS.eq((combat.facade.brain.isWinnable("a fixture brute")), true, "a plain mob is fine")
DOCS.eq(d.ability, "Fixture Strike", "the AE is vetoed with a guard in reach")
DOCS.eq(#w.world.casts, 1, "one cast went out")
DOCS.eq(w.world.casts[1].target, 200, "...at the brute")
