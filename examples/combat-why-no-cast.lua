-- EB tested example: Why does the engine not cast that?
-- combat-why-no-cast | snippet | topics: combat, helpers
--
-- What it does:  Ask the engine which gate holds each entry of your stack right now - on recast, below its power line, its tag
--                switched off, its target-health window not reached - then send a cast of your own through the engine's one send.
-- Tested:        Each entry names the gate that holds it (TargetHPBelow, Ready, PowerAbove, Toggled) or "would cast"; the
--                hand-made decision is sent to the game.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { powerPct = 30 } })
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Finisher", "Fixture Smash", "Fixture Nuke", "Fixture Cleave", "Fixture Strike" })
FW.recast(w, "Fixture Smash", 10)                         -- offline: it is on recast in the game
FW.mob(w, { id = 200, name = "a fixture brute", healthPct = 80 })
FW.target(w, 200)

-- your script
local game = require("eb.platform").game()
local Combat = require("eb.combat")
local stack = require("eb.caststack.jsonstack").holder({ entries = {
    { name = "Fixture Finisher", ability = "Fixture Finisher", group = "dps", tags = "CA", priority = 99,
      gates = { useBelowTargetHP = 20 } },                               -- only under 20% target health
    { name = "Fixture Smash",  ability = "Fixture Smash",  group = "dps", tags = "CA", priority = 98, gates = {} },
    { name = "Fixture Nuke",   ability = "Fixture Nuke",   group = "dps", tags = "CA", priority = 97,
      gates = { useAbovePower = 50 } },                                  -- only above 50% of your power
    { name = "Fixture Cleave", ability = "Fixture Cleave", group = "dps", tags = "AE", priority = 96, gates = {} },
    { name = "Fixture Strike", ability = "Fixture Strike", group = "dps", tags = "CA", priority = 90, gates = {} },
} })
local engine = Combat.new({ shim = game.combatShim(), stacks = stack })
engine:toggle("AE", false)                                 -- AE switched off for this pull

-- what a step does before its categories: the stack, one world read, the mob it would fight
engine:loadStack()
local ctx = engine:snapshot()
ctx.mob = engine:selectTarget(ctx)
local held = {}
for _, e in ipairs(stack.entries()) do
    local why = engine:passesGate(e, ctx, ctx.mob)         -- nil = it would cast now
    held[e.name] = why or "would cast"
    print(("%s held by %s"):format(e.name, why or "nothing: would cast"))
end

-- a cast of your own through the engine's one send (the same path its own decisions take)
local mine = Combat.U.decision("dps", stack.get("Fixture Strike"), "Target", "by hand")
local sent = engine:cast(mine)

-- check
DOCS.eq(held["Fixture Finisher"], "TargetHPBelow", "the target is not low enough yet")
DOCS.eq(held["Fixture Smash"], "Ready", "on recast: the game says it is not ready")
DOCS.eq(held["Fixture Nuke"], "PowerAbove", "you are under its power line")
DOCS.eq(held["Fixture Cleave"], "Toggled", "its AE tag is switched off")
DOCS.eq(held["Fixture Strike"], "would cast", "the one that passes every gate")
DOCS.eq(sent, true, "the hand-made decision was sent")
DOCS.eq(FW.casts(w)[1], "Fixture Strike", "and reached the game")
