-- The combat plane, its facade and the follower view
--
-- Build the combat plane the way EB does, see its one step throttle, record an encounter's damage rules on the facade, and run an instance's pull / clear / engage through the follower-aware view.
--
-- kind:      snippet
-- expect:    Two steps in the same moment answer one decision; a follower never pulls or clears, and its engage waits until the lead's target is down; the facade records the damage rules.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.app.combat, eb.wiring.combat_facade
-- id:        combat-facade-views

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Strike" })
local brute = FW.mob(w, { id = 200, name = "a fixture brute" })
FW.target(w, 200)

-- your script
local game = require("eb.platform").game()
local AppCombat = require("eb.app.combat")
local plane = AppCombat.new({ game = game, clock = w.P.now, sleep = function(ms) eb.delay(ms) end })
plane.holder.rebind({ entries = {
    { name = "Fixture Strike", ability = "Fixture Strike", group = "dps", tags = "CA", priority = 90, gates = {} } } })

local a = plane.engine:step()
local b = plane.engine:step()                               -- the same moment: the same decision, no second cast

local facade = require("eb.wiring.combat_facade").new({ engine = plane.engine, game = game })
local rulesBefore = facade.ic.damageSource()
facade.ic.setRules("burst")
local rulesNow = facade.ic.damageSource()

local follower = plane.icView({ lead = function() return false end })   -- this box is not the one that pulls
local okP, pulled = follower.pull("a fixture brute")
local okC, cleared = follower.clearArea()
local t0 = w.now()                                          -- offline: the lead kills the brute a second from now
w.world.onFrame = function() if w.now() - t0 > 1000 then brute.healthPct, brute.isDead = 0, true end end
local engaged = w.task(function()                           -- a follower's engage waits: inside a task
    local ok, note = follower.engage("a fixture brute", { ms = 10000 })
    return note
end, 20000)
print("follower: " .. pulled .. " | " .. tostring(engaged))

local none, why = AppCombat.findStack({ files = { read = function() return nil end, list = function() return {} end },
                                       dirs = {}, char = "Fixturae" })

-- check
DOCS.check(a == b, "two steps in one moment answer one decision")
DOCS.eq(#FW.casts(w), 1, "and only one cast went out")
DOCS.eq(rulesBefore, "default", "the facade's damage rules start as default")
DOCS.eq(rulesNow, "burst", "and record what the encounter set")
DOCS.eq(pulled, "the lead pulls a fixture brute", "a follower never pulls")
DOCS.eq(cleared, "the lead clears the area", "nor clears an area on its own")
DOCS.eq(engaged, "assisting on a fixture brute: down", "its engage waited for the lead's kill")
DOCS.eq(none, nil, "no profile folder known: no stack")
DOCS.check(type(why) == "string" and #why > 0, "and a plain reason")
