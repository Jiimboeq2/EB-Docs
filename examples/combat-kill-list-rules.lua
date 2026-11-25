-- EB tested example: The kill-first list, rules and stragglers
-- combat-kill-list-rules | snippet | topics: combat, fights, instances
--
-- What it does:  Give the engine a kill-first list with a health rule, see how it ranks and filters the mobs in the fight, hold
--                it for a moment, hand it a straggler, and ask for the trash first.
-- Tested:        The scout is first on the list but skipped while under 50% health, so the brute is picked; a held list falls
--                back to the nearest hostile; a straggler is engaged when handed over; trash-first prefers a non-named.
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
FW.mob(w, { id = 201, name = "a fixture scout", healthPct = 30, distance = 8 })
FW.mob(w, { id = 202, name = "a fixture brute", healthPct = 90, distance = 6 })
FW.mob(w, { id = 203, name = "Overseer of Fixtures", type = "NamedNPC", distance = 3 })
FW.mob(w, { id = 204, name = "a fixture straggler", distance = 12 })

-- your script
local game = require("eb.platform").game()
local engine = require("eb.combat").new({ shim = game.combatShim(), stacks = { entries = function() return {} end } })
engine:setAutoTarget({ { name = "a fixture scout", hp = 50 }, "a fixture brute" })   -- order = priority

local ctx = engine:snapshot()
local scout = engine:findHostile("scout")
local rule, rank = engine:killListMatch(scout)                    -- its row on the list, and its place
local scoutOk = engine:eligibleMob(ctx, scout, rule)              -- under its 50% rule: not now
local pick = engine:scanAutoTarget(ctx)
print("kill list picks: " .. tostring(pick and pick.name))

engine:suppressAutoTarget("waiting for the tank")                 -- hold the list for a reason of your own
local held = engine:autoTargetSuppressed()
local fallback = engine:selectTarget(ctx)                         -- held: the nearest hostile in the fight
engine:releaseAutoTarget("waiting for the tank")

engine:addTarget(204, "a fixture straggler")                      -- a mob nobody is fighting: take it
local straggler = engine:pickStraggler(ctx)
local has = engine:hasStragglers()
engine:clearStragglers()

local trash = engine:pickTrashFirst(ctx)                          -- what an override's trashFirst prefers
local rows = engine:normalizeKillList({ "A Fixture Brute" })
local eff = engine:effAutoTarget()

-- check
DOCS.eq(rank, 1, "the scout is first on the list")
DOCS.eq(scoutOk, false, "but its 50% rule keeps it out at 30% health")
DOCS.eq(pick.name, "a fixture brute", "so the list picks the brute")
DOCS.eq(held, true, "the list can be held")
DOCS.eq(fallback.name, "Overseer of Fixtures", "and selection falls back to the nearest hostile")
DOCS.eq(engine:autoTargetSuppressed(), false, "released again")
DOCS.eq(straggler and straggler.id, 204, "a handed-over straggler is engaged")
DOCS.eq(has, true, "while it is held")
DOCS.eq(engine:hasStragglers(), false, "until cleared")
DOCS.eq(trash.name, "a fixture brute", "trash first: the nearest eligible non-named")
DOCS.eq(rows[1].name, "a fixture brute", "list rows are read lower case")
DOCS.eq(eff.enabled, true, "a non-empty list switched auto-target on")
