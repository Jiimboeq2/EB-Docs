-- EB tested example: The combat plane EB runs
-- combat-app-plane | snippet | topics: combat
--
-- What it does:  eb.app.combat is what EB builds once per box: the cast stack holder, the engine and the facade, plus the pump
--                the pulse calls 4 times a second.
-- Tested:        With no stack it says so; after a stack is bound the holder serves its 2 entries, and a pump sends one cast.
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
FW.book(w, { "Fixture Strike", "Fixture Smash" })
FW.mob(w, { id = 200, name = "a fixture brute" })
FW.target(w, 200)

-- your script
local P = require("eb.platform")
local combat = require("eb.app.combat").new({ game = P.game(), clock = P.now })
print(combat.describe())                                -- no stack found yet: it says why
combat.holder.rebind({ entries = {
    { name = "Fixture Strike", ability = "Fixture Strike", group = "dps", tags = "CA", priority = 90, gates = {} },
    { name = "Fixture Smash",  ability = "Fixture Smash",  group = "dps", tags = "CA", priority = 80, gates = {} },
}, held = {}, unknown = {}, skipped = {}, gaps = {} })
print(require("eb.caststack.jsonstack").summary(combat.holder.result))   -- counts only, never a name
local d = combat.pump(P.now())                         -- what the pulse job does every 250 ms
local again = combat.pump(P.now())                     -- too soon: nothing (one throttle for every caller)

-- check
DOCS.eq(#combat.holder.entries(), 2, "the holder serves the bound stack")
DOCS.eq(d and d.ability, "Fixture Strike", "one pump, one decision")
DOCS.eq(again, nil, "a second pump inside 250 ms does nothing")
DOCS.eq(#w.world.casts, 1, "one cast went out")
