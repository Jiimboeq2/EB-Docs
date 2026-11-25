-- What GetVar does with a member that is not verified yet
--
-- EB only sends members verified to work. GetVar on a member that is not verified yet sends nothing and answers your default; GateSkipped() lists what was held back.
--
-- kind:      snippet
-- expect:    The not-yet-verified member answers the default, nothing is sent to the game, and GateSkipped names it.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        tlo-getvar-not-verified

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()

-- your script
local game = require("eb.platform").game()
local before = w.host.stats.getvar
local arch = game.GetVar("Me.Archetype", "unknown")              -- not verified yet: held back
print(("archetype: %s (held back, %d reads)"):format(arch, w.host.stats.getvar - before))
local held = table.concat(game.GateSkipped(), ", ")

-- check
DOCS.eq(arch, "unknown", "your default, never a guess")
DOCS.eq(w.host.stats.getvar - before, 0, "nothing reached the game")
DOCS.has(held, "Me.Archetype", "GateSkipped lists it")
DOCS.eq(game.Me().subclass, "warden", "the game layer's own reads still answer")
