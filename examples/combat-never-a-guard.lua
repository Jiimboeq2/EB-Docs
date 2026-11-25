-- Guards are never pulled or splashed
--
-- Ask the combat plane whether a target is winnable before you pull: a guard is refused. With a guard standing in AE reach of your fight, the engine skips its AE and casts a single-target art instead.
--
-- kind:      snippet
-- expect:    isWinnable refuses the guard ("guard") and accepts the brute; the AE is vetoed while the guard is near, and the single-target art goes out at the brute.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.app.combat, eb.combat
-- id:        combat-never-a-guard

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
