-- The combat plane EB runs
--
-- eb.app.combat is what EB builds once per box: the cast stack holder, the engine and the facade, plus the pump the pulse calls 4 times a second.
--
-- kind:      snippet
-- expect:    With no stack it says so; after a stack is bound the holder serves its 2 entries, and a pump sends one cast.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.app.combat
-- id:        combat-app-plane

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
