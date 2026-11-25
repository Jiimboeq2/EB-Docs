-- Check a subsystem against its contract
--
-- eb.brain.contracts names what each subsystem gives the brain: validate yours, use the stubs meanwhile.
--
-- kind:      snippet
-- expect:    A nav table with two of six functions is missing four; the stubs answer the contract's statuses.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.brain.contracts
-- id:        world-contracts

-- your script
local C = require("eb.brain.contracts")
local myNav = {
    walkTo = function(x, y, z, opts) return "working" end,      -- every action is non-blocking: call it each tick
    stop = function() end,
}
local ok, missing = C.validate("nav", myNav)
print("nav missing: " .. table.concat(missing, ", "))

local notes = {}
local stubs = C.stubs(function(line) notes[#notes + 1] = line end)
local status, why = stubs.nav.walkTo(1, 2, 3)
local engaged = stubs.combat.engage({ name = "a cave bat" })
local travel = stubs.nav.travelTo("fixture_hollow", { pack = true })   -- only the zone's own transit, ever
local moved, state = stubs.nav.progress()
local fight = stubs.combat.clear()
local step = stubs.quests.step({})
local gate = stubs.relay.barrier("door")
local report, allOk = C.check({ nav = myNav })

-- check
DOCS.eq(ok, false, "not complete yet")
DOCS.eq(#missing, 4, "four functions missing")
DOCS.eq(status, "blocked", "a stub says blocked")
DOCS.eq(why, "no nav", "with a reason")
DOCS.eq(engaged, "refused", "a stub combat engine refuses a pull")
DOCS.has(notes[1], "STUB: nav.walkTo", "the first use of a stub is noted once")
DOCS.eq(travel, "blocked", "travelTo answers a status word")
DOCS.eq(state, "idle", "progress says the walk state")
DOCS.eq(fight, "clear", "no fight: clear")
DOCS.eq(step, "blocked", "a quest step status")
DOCS.eq(gate, "ready", "a barrier status")
DOCS.check(not allOk and report.nav.ok == false, "check reports every subsystem")
DOCS.eq(#C.SPECS.world, 1, "the world contract is one call: snapshot")
