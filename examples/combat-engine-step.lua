-- One engine step, one decision
--
-- Build the combat engine over the game layer's combat shim and a small cast stack, and step it: each step casts the highest-priority entry that is ready.
--
-- kind:      snippet
-- expect:    Step 1 casts the AE (priority 99); with it on recast step 2 casts the next art (97), step 3 the one after (95).
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.combat, eb.caststack.jsonstack
-- id:        combat-engine-step

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
