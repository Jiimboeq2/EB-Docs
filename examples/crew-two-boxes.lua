-- EB tested example: Two boxes, one crew
-- crew-two-boxes | snippet | topics: crew, helpers
--
-- What it does:  eb.relay carries scoped lines between boxes: all reaches everyone once, others skips the sender, to names who.
-- Tested:        all runs once on each box, others only on the other one, to is2 only on is2.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
