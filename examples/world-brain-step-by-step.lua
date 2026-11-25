-- Step a brain by hand
--
-- Every part of a brain tick on its own: the snapshot, the events it answers, the stuck watch, choosing and driving an interrupt, the goal stack, the resume point and the log - over stand-in subsystems you control.
--
-- kind:      snippet
-- expect:    The stand-ins pass the contract check; the rez offer is accepted; the fight interrupt is chosen and clears; setGoal / popGoal move the stack; the resume point is handed to persist once.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.brain, eb.brain.contracts, eb.world
-- id:        world-brain-step-by-step

-- your script: stand-in subsystems (C.stubs) with the few calls this example drives replaced
local Brain = require("eb.brain")
local C = require("eb.brain.contracts")
local deps = C.stubs()
local answered, saved = {}, {}
deps.events = { poll = function() return { { kind = "rez_offer", from = "Mendwell" } } end,
                answer = function(ev, choice) answered[#answered + 1] = ev.kind .. ":" .. choice end }
deps.world = { snapshot = function()
    return { inGame = true, hated = true, x = 0, y = 0, z = 0, zone = "fixture_hollow", hpPct = 90, powerPct = 80,
             bagsFreeSlots = 10, group = { count = 1, members = {} } }
end }
local report, allOk = C.check(deps)
local lines = {}
local b = Brain.new(deps, { log = function(l) lines[#lines + 1] = l end, persist = function(p) saved[#saved + 1] = p end,
    persistThrottleMs = 0 })

local snap = b:snapshot(0)
b:consumeEvents(snap)                              -- answers the rez offer itself, never asks
b:trackProgress(snap, 250)
local irq = b:selectInterrupt(snap)                -- a fight is on: the combat interrupt
local drove = b:driveInterrupt(irq, snap)
b:setGoal({ name = "camp", ctx = { phase = "select" }, advance = function() return "working" end,
            describe = function() return "camp[select]" end })
b:markPointer()
b:persistMaybe(1000)
local pointer = b:goalPointer()
b:popGoal()
b:log("stepped %d parts by hand", 8)
b:stop()
print(("rez %s | %s | goal after pop: %s | saved %s@%s"):format(answered[1]:match("accept") and "accepted" or "?",
    drove, b:activeGoal() and "some" or "none", saved[1].goal, saved[1].phase))

-- check
DOCS.check(allOk, "the stand-ins have every contract function")
DOCS.eq(#C.SPECS.nav, 6, "the nav contract names six calls")
DOCS.eq(answered[1], "rez_offer:accept", "the rez offer was accepted")
DOCS.eq(irq.name, "combat", "the fight interrupt was chosen")
DOCS.eq(pointer.goal, "camp", "the resume point names the goal")
DOCS.check(b.halted, "stop halts the brain for the session")
DOCS.has(lines[#lines], "stepped 8 parts", "b:log writes the brain's log")
DOCS.eq(require("eb.world").archetypeOf("templar"), "priest", "the world knows a subclass's archetype")
