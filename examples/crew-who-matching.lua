-- Address boxes by box, name, class or archetype
--
-- A to <who> list may name a box id, a character, a class or an archetype; wire.shouldHandle decides who acts.
--
-- kind:      snippet
-- expect:    to priest reaches the templar, to @fighter the guardian, to is3 only is3, and others never the sender.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.relay.wire
-- id:        crew-who-matching

-- your script
local wire = require("eb.relay.wire")
local boxes = {
    { box = "is1", name = "Tankard", subclass = "guardian" },
    { box = "is2", name = "Mendwell", subclass = "templar" },
    { box = "is3", name = "Sparkwick", subclass = "wizard" },
}
local function who(scope, list, from)
    local out = {}
    for _, me in ipairs(boxes) do
        if wire.shouldHandle({ scope = scope, who = list, from = from or "is1" }, me) then out[#out + 1] = me.box end
    end
    return table.concat(out, ",")
end
print("priest -> " .. who("to", "priest"))

-- check
DOCS.eq(who("to", "priest"), "is2", "an archetype")
DOCS.eq(who("to", "@fighter"), "is1", "@archetype")
DOCS.eq(who("to", "templar,is3"), "is2,is3", "a class and a box id together")
DOCS.eq(who("to", "sparkwick"), "is3", "a character name, any case")
DOCS.eq(who("others", ""), "is2,is3", "others never reaches the sender")
DOCS.eq(who("all", ""), "is1,is2,is3", "all reaches everyone")
DOCS.eq(wire.archetype("dirge"), "scout", "the archetype of a class")
