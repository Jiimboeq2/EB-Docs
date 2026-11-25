-- EB tested example: Lock the engine onto one mob
-- combat-target-lock | snippet | topics: combat, fights
--
-- What it does:  A target lock outranks assist and the kill list: the engine picks the locked mob while it is a fair fight, and
--                falls back to your target when the lock is cleared.
-- Tested:        With the lock on the adds' caller the engine picks it over your target; cleared, it picks your target again.
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
FW.mob(w, { id = 200, name = "a fixture brute", distance = 5 })
FW.mob(w, { id = 201, name = "a fixture caller", distance = 9 })
FW.target(w, 200)

-- your script
local game = require("eb.platform").game()
local engine = require("eb.combat").new({ shim = game.combatShim(), stacks = { entries = function() return {} end } })

engine:lockTarget(201)                                   -- a fight script: "kill the caller first"
local locked = engine:selectTarget(engine:snapshot())
print("locked: " .. locked.name)
engine:clearLock()
local free = engine:selectTarget(engine:snapshot())
print("unlocked: " .. free.name)

-- check
DOCS.eq(locked.id, 201, "the lock wins over the current target")
DOCS.eq(free.id, 200, "cleared: the current target again")
engine:setAssist("Member1")
DOCS.eq(engine.assistName, "Member1", "an assist anchor is kept the same way (clearAssist undoes it)")
