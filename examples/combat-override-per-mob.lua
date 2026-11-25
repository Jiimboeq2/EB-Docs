-- Overrides per zone, per mob, and a timed pause
--
-- Register a zone override and a stronger one for one mob, see which wins and what each switch reads while it applies, then pause every cast for one second with a temporary manual override.
--
-- kind:      snippet
-- expect:    On the brute the mob override wins: burn tag forced off, mez off, interrupt the listed cast, stand behind, ask for another stack; the zone override's interrupt-all still applies; the manual pause holds casts for a second.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.combat.overrides, eb.combat
-- id:        combat-override-per-mob

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Strike" })
FW.recastOnUse(w, 1)                                       -- the game shows each cast as taken: the art goes on a second's reuse
FW.mob(w, { id = 200, name = "a fixture brute" })
FW.target(w, 200)

-- your script
local game = require("eb.platform").game()
local engine = require("eb.combat").new({ shim = game.combatShim(), stacks = { entries = function() return {
    { name = "Fixture Strike", ability = "Fixture Strike", group = "dps", tags = "CA", priority = 90, gates = {} } } end } })

local zone = { name = "hall rules", priority = 1, match = { zone = "a test hall" }, directives = { interruptAll = true } }
engine:addOverride(zone)
engine:addOverride({ name = "brute rules", priority = 5, match = { mob = "brute" }, directives = {
    tags = { BURN = false }, disableMez = true, positioning = "behind", interruptList = { "Fixture Blast" },
    stack = "brute stack" } })

local d = engine:step()                                    -- a step resolves the overrides first
print("active override: " .. engine:activeOverride().name)
local matched = engine:overrideMatches(zone, engine:snapshot())
local read = { mez = engine:moduleOn("mez"), burn = engine:tagForcedOff("BURN"), all = engine:effInterruptAll(),
               list = engine:effInterruptList()["fixture blast"], pos = engine:effPosition().mode,
               stack = engine:activeStackName(), raw = engine:ovGet("disableMez") }

engine:setOverride({ pause = true }, { ttlMs = 1000, name = "hold a second" })
w.runFor(250)
local held = engine:step()
local paused = engine:isPaused()
w.runFor(1100)
local after = engine:step()

-- check
DOCS.eq(d.ability, "Fixture Strike", "the rotation runs under the overrides")
DOCS.eq(matched, true, "the zone override applies too")
DOCS.eq(read.mez, false, "mez off on the brute")
DOCS.eq(read.burn, true, "the burn tag forced off")
DOCS.eq(read.all, true, "interrupt-all from the zone override")
DOCS.eq(read.list, true, "and the brute's listed cast")
DOCS.eq(read.pos, "behind", "stand behind it")
DOCS.eq(read.stack, "brute stack", "the stack this context asks for")
DOCS.eq(read.raw, true, "one resolved directive")
DOCS.eq(held.reason, "paused", "the manual override holds every cast")
DOCS.eq(paused, true, "while it lasts")
DOCS.eq(after.ability, "Fixture Strike", "and lets go after its second")
