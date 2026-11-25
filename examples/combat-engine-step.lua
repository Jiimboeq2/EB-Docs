-- EB tested example: One engine step, one decision
-- combat-engine-step | snippet | topics: combat
--
-- What it does:  Build the combat engine over the game layer's combat shim and a small cast stack, and step it: each step casts
--                the highest-priority entry that is ready.
-- Tested:        Step 1 casts the AE (priority 99); with it on recast step 2 casts the next art (97), step 3 the one after (95).
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
FW.book(w, { "Fixture Cleave", "Fixture Strike", "Fixture Smash" })
FW.recastOnUse(w, 10)
FW.mob(w, { id = 200, name = "a fixture brute" })
FW.target(w, 200)

-- your script
local game = require("eb.platform").game()
local Combat = require("eb.combat")
local stack = require("eb.caststack.jsonstack").holder({ entries = {      -- the entry shape the engine runs
    { name = "Fixture Cleave", ability = "Fixture Cleave", group = "dps", tags = "AE", priority = 99, gates = {} },
    { name = "Fixture Strike", ability = "Fixture Strike", group = "dps", tags = "CA", priority = 97, gates = {} },
    { name = "Fixture Smash",  ability = "Fixture Smash",  group = "dps", tags = "CA", priority = 95, gates = {} },
} })
local engine = Combat.new({ shim = game.combatShim(), stacks = stack })

local picks = {}
for i = 1, 3 do
    local d = engine:step()                   -- ONE decision: a cast it sent, or a hold with a reason
    print(("step %d: %s %s (%s)"):format(i, tostring(d.kind), tostring(d.ability), tostring(d.reason)))
    picks[i] = d.ability
    w.runFor(500)                              -- EB steps the engine 4 times a second; a quick art goes out at most every half second
end

-- check
DOCS.eq(picks[1], "Fixture Cleave", "highest priority first")
DOCS.eq(picks[2], "Fixture Strike", "the next once the first is on recast")
DOCS.eq(picks[3], "Fixture Smash", "and the one after")
DOCS.eq(#FW.casts(w), 3, "each decision was sent to the game")
