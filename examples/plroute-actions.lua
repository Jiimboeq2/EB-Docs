-- A route's actions, one bite at a time
--
-- An actions step is a list of single actions; eb.plroutes.actions runs one per call and says where it is. A go in another zone hands the zone back as need_travel; a wait counts on the snapshot's clock; a click goes to the act adapter. resolveTarget and actionTarget say what a step or an action is about without running it.
--
-- kind:      snippet
-- expect:    The go asks for travel first, the wait finishes after its seconds, the click is done, and an instance step queues one run through the instance adapter.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.plroutes.actions, eb.plroutes.runner
-- id:        plroute-actions

local A = require("eb.plroutes.actions")
local runner = require("eb.plroutes.runner")

-- the adapters an actions step uses (offline: recorders)
local clicked, queued = nil, nil
local deps = {
    nav = { walkTo = function() return "arrived" end },
    act = { click = function(name) clicked = name; return true end },
    ic = { queue = function(ic) queued = ic end, state = function() return "idle" end },
}
local snap = { now = 0, zone = "Fixture Docks" }

-- your script
local go = { kind = "go", zone = "Fixture Vale", at = { x = 4, y = 0, z = 9 } }
local s1, z1 = A.runAction(go, snap, deps, {})
print("go: " .. s1 .. " " .. z1)
local wait, ws = { kind = "wait", secs = 3 }, {}
local w1 = A.runAction(wait, snap, deps, ws)
snap.now = 3000
local w2 = A.runAction(wait, snap, deps, ws)
local c = A.runAction({ kind = "click", actor = "Warden Fixturo", how = "doubleclick" }, snap, deps, {})
local target = runner.resolveTarget({ kind = "actions", actions = { go } }, 1)
local inst = A.instance({ route = { recovery = {} } }, snap, { kind = "instance", ic = "fixture_hollow" }, deps)

-- check
DOCS.eq(s1, "need_travel", "a go in another zone asks for travel first")
DOCS.eq(w1, "working", "the wait is still counting")
DOCS.eq(w2, "done", "and done after its seconds")
DOCS.eq(c, "done", "the click went to the act adapter")
DOCS.eq(clicked, "Warden Fixturo", "on the named actor")
DOCS.eq(A.actStatus("refused"), "blocked", "an adapter's refusal reads as blocked")
DOCS.eq(target.kind, "go", "resolveTarget names the step's first action")
DOCS.eq(A.actionTarget(go).zone, "Fixture Vale", "actionTarget names its zone")
DOCS.eq(inst, "working", "an instance step starts a run")
DOCS.eq(queued, "fixture_hollow", "through the instance adapter")
