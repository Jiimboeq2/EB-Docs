-- EB tested example: Give up a fight that cannot be won
-- combat-giveup-unwinnable | snippet | topics: combat, fights
--
-- What it does:  The engine measures each fight's kill time from two health readings; past the grace window, a mob it picked
--                itself whose kill time stays over the limit is benched for the session. What the tank or you fight (and an
--                ordered kill) is never given up - a training dummy is there to be hit. An override caps both for a hard zone.
-- Tested:        With a 1-second grace and a 2-second cap, a mob EB picked whose health never moves is given up ("tooStrong") and
--                benched until forgetStrong(); the dummy you targeted is still fought; the kill time of a mob that does lose
--                health is measured.
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
FW.mob(w, { id = 200, name = "a fixture colossus", healthPct = 100 })                    -- on you; nobody targeted it
FW.mob(w, { id = 201, name = "a fixture training dummy", healthPct = 100, distance = 4 })
FW.target(w, 201)                                                                       -- you have the dummy targeted

-- your script
local game = require("eb.platform").game()
local Combat = require("eb.combat")
local engine = Combat.new({ shim = game.combatShim(), stacks = { entries = function() return {} end } })
engine:setOverride({ ttkGrace = 1000, ttkMax = 2000 })    -- a hard zone: judge after 1 s, give up past 2 s

local function mobIn(ctx, id) for _, m in ipairs(ctx.hostiles) do if m.id == id then return m end end end
local ctx = engine:snapshot()
engine.ov = engine:resolveOverride(ctx)                    -- what a step does first
local grace, cap = engine:ttkGrace(), engine:ttkMax()
local first = engine:winnable(ctx, mobIn(ctx, 200))        -- the first reading only starts the measure

w.runFor(1500)                                             -- the fights go on; no health moves
ctx = engine:snapshot()
local ok, why = engine:winnable(ctx, mobIn(ctx, 200))
print("gave up: " .. tostring(why))
local benched = engine:isTooStrong("a fixture colossus")
local dummy = engine:winnable(ctx, ctx.target)             -- your own target: never given up
engine:forgetStrong()                                      -- after a gear upgrade, say

local eta = Combat.killEta(100, 60, 20000)                 -- lost 40% in 20 s: 60% left = 30 s more

-- check
DOCS.eq(grace, 1000, "the override's grace window")
DOCS.eq(cap, 2000, "the override's give-up limit")
DOCS.eq(first, true, "the first reading keeps fighting")
DOCS.eq(ok, false, "no progress past the grace window: given up")
DOCS.eq(why, "tooStrong", "with the reason")
DOCS.eq(benched, true, "and benched for the session")
DOCS.eq(dummy, true, "the dummy you targeted is still fought")
DOCS.eq(engine:isTooStrong("a fixture colossus"), false, "until forgetStrong()")
DOCS.eq(eta, 30000, "the kill time two readings imply")
