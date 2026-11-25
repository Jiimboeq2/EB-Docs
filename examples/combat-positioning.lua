-- Where to stand, and line of sight
--
-- Ask the engine to position behind the mob: every decision then carries where it would stand - EB does not move in a fight for it yet (moves = false, said once in the console). A positional entry waits for its angle when the angle can be read, and the line-of-sight gate holds casts through a wall.
--
-- kind:      snippet
-- expect:    The decision says it would stand "behind" at 3 m and that nothing moves the box (moves = false); an unreadable angle never blocks; with the angle read as "front", a behind-only art waits; with the line blocked and the gate on, nothing is cast.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.combat.combat_pos, eb.combat.overrides, eb.combat
-- id:        combat-positioning

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Strike" })
local brute = FW.mob(w, { id = 200, name = "a fixture brute" })
FW.target(w, 200)

-- your script
local game = require("eb.platform").game()
local Combat = require("eb.combat")
local strike = { name = "Fixture Strike", ability = "Fixture Strike", group = "dps", tags = "CA", priority = 90,
                 gates = {} }
local engine = Combat.new({ shim = game.combatShim(), stacks = { entries = function() return { strike } end } })
engine:setPosition("behind", 3)

local d = engine:step()
print(("position: %s %d m"):format(d.position.mode, d.position.range))
local ctx = engine:snapshot()
ctx.mob = engine:selectTarget(ctx)
local plan = engine:planPosition(ctx)
local angle = engine:relativeAngle(ctx, ctx.mob)                 -- no facing on the mob rows: unknown
local open = engine:positionalFail("behind", ctx.mob)            -- unknown never blocks

local shim = game.combatShim()                                   -- offline: an angle read, to show the gate working
shim.behindTarget = function() return false end
shim.inFrontTarget = function() return true end
local angled = Combat.new({ shim = shim, stacks = { entries = function() return { strike } end } })
local front = angled:relativeAngle(ctx, ctx.mob)
local waits = angled:positionalFail("behind", ctx.mob)

engine:setLoSGate(true)
brute.los = false                                                -- offline: a wall between you and the brute
w.runFor(250)
local blocked = engine:losFail(engine:snapshot().target)
local hold = engine:step()

-- check
DOCS.eq(d.position.mode, "behind", "the decision carries where to stand")
DOCS.eq(d.position.targetId, 200, "relative to the mob being fought")
DOCS.eq(plan.range, 3, "at 3 metres")
DOCS.eq(angle, nil, "the angle cannot be read here")
DOCS.eq(open, nil, "so a positional art is never held for it")
DOCS.eq(front, "front", "with an angle read: in front of it")
DOCS.eq(waits, "Positional[behind]", "a behind-only art waits for the angle")
DOCS.eq(engine:losActive(), true, "the line-of-sight gate is on")
DOCS.eq(blocked, true, "the line to the brute is blocked")
DOCS.eq(hold.hold, true, "so nothing is cast through the wall")
DOCS.eq(d.position.moves, false, "nothing moves the box for it")
