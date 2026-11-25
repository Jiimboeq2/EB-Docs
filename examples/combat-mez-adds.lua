-- Mez the adds, renew before it breaks
--
-- With a mez art in the stack the engine mezzes the adds in the mez list's order - never the mob being killed, never a guard, never an epic - and renews a mez that has 10 seconds or less left.
--
-- kind:      snippet
-- expect:    The imp is mezzed first (first on the mez list), then the hound; the imp's mez is renewed once it runs low.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.combat.mez, eb.combat
-- id:        combat-mez-adds

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Mesmerize", "Fixture Strike" })
FW.recastOnUse(w, 1)                                                       -- the game shows each cast as taken: the art goes on a second's reuse
FW.mob(w, { id = 200, name = "a fixture brute", distance = 4 })            -- the mob being killed
FW.mob(w, { id = 201, name = "a fixture imp", distance = 9 })
FW.mob(w, { id = 202, name = "a fixture hound", distance = 5 })
FW.mob(w, { id = 203, name = "a fixture sentry", distance = 7 })           -- a guard: never touched
FW.mob(w, { id = 204, name = "a fixture behemoth", isEpic = true, distance = 6 })
FW.target(w, 200)

-- your script
local game = require("eb.platform").game()
local stack = require("eb.caststack.jsonstack").holder({ entries = {
    { name = "Fixture Mesmerize", ability = "Fixture Mesmerize", group = "dps", tags = "MEZ", priority = 50, gates = {} },
    { name = "Fixture Strike", ability = "Fixture Strike", group = "dps", tags = "CA", priority = 90, gates = {} },
} })
local engine = require("eb.combat").new({ shim = game.combatShim(), stacks = stack })
engine:setMezList({ "imp" })                                                -- the imp first, whatever is nearer

-- a mez is cast at the add by its id, which leaves the add targeted: point the target back at the kill mob after it
local function stepKeepingTarget(killId)
    local d = engine:step()
    if d.kind == "mez" then game.TargetActor(killId) end
    return d
end

-- EB steps the engine 4 times a second: the next step sees that the game took the cast. The same art goes at the next
-- add only once its reuse is over (a second here), so the clock runs on before the step after that.
local function afterCast()
    w.runFor(250); engine:step()
    w.runFor(1000)
end

local log = {}
local d1 = stepKeepingTarget(200); log[1] = d1.reason
w.addMaintained({ name = "Fixture Mesmerize", targetId = 201, duration = 30 })   -- offline: the imp is mezzed
afterCast()
local d2 = stepKeepingTarget(200); log[2] = d2.reason
w.addMaintained({ name = "Fixture Mesmerize", targetId = 202, duration = 30 })
w.world.maintained[1].duration = 6                                          -- the imp's mez runs low
afterCast()
local d3 = stepKeepingTarget(200); log[3] = d3.reason
print("mez order: " .. table.concat(log, " | "))

engine:loadStack()
local arts = engine:mezEntries()
local rankImp, rankHound = engine:mezRank({ name = "a fixture imp" }), engine:mezRank({ name = "a fixture hound" })
local epic = engine:mezImmune({ id = 204, isEpic = true })

-- check
DOCS.eq(d1.kind, "mez", "an add needs a mez before the rotation")
DOCS.eq(d1.target, 201, "the imp first: it is first on the mez list")
DOCS.eq(d2.target, 202, "then the hound")
DOCS.eq(d3.reason, "renew mez a fixture imp", "a mez with 6 seconds left is renewed")
DOCS.eq(#arts, 1, "the mez arts in the stack")
DOCS.eq(rankImp, 1, "the imp's place on the list")
DOCS.eq(rankHound, 2, "an add not on the list comes after it")
DOCS.eq(epic, true, "an epic is treated as immune")
DOCS.check(d1.target ~= 203 and d2.target ~= 203 and d3.target ~= 203, "the guard was never mezzed")
