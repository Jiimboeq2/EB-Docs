-- Two boxes, one crew
--
-- eb.relay carries scoped lines between boxes: all reaches everyone once, others skips the sender, to names who.
--
-- kind:      snippet
-- expect:    all runs once on each box, others only on the other one, to is2 only on is2.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.relay, eb.relay.events
-- id:        crew-two-boxes

-- offline stand-in: an offline relay bus between two boxes (in game each box's relay rides InnerSpace's own)
local bus = require("eb.relay.events").bus()

-- your script: one relay per box; onLocal is what a box does with a line meant for it
local Relay = require("eb.relay")
local function box(id, name, subclass)
    local ran = {}
    local R = Relay.new({ box = id, name = name, subclass = subclass, transport = bus.box(id) })
    R.onLocal(function(line, env) ran[#ran + 1] = line end)
    R.join()                                   -- opt in: nothing is sent or heard before join()
    return R, ran
end
local tank, tankRan = box("is1", "Tankard", "guardian")
local heal, healRan = box("is2", "Mendwell", "templar")

tank.send("all pause")                         -- everyone, the sender included (it acts at once)
tank.send("others stop")                       -- everyone but the sender
tank.send("to is2 follow is1")                 -- only box is2
print(("is1 ran: %s | is2 ran: %s"):format(table.concat(tankRan, ", "), table.concat(healRan, ", ")))

-- check
DOCS.eq(table.concat(tankRan, ","), "pause", "the sender ran all once and nothing else")
DOCS.eq(table.concat(healRan, ","), "pause,stop,follow is1", "the other box ran each line meant for it, once")
local dec = tank.send("to is2 all pause")
DOCS.eq(dec.ok, false, "a line may carry only one scope word")
