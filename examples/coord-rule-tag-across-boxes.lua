-- EB tested example: When the tank shouts, the healer reacts
-- coord-rule-tag-across-boxes | snippet | topics: crew, fights, helpers
--
-- What it does:  Two boxes, two rules: the tank's cast fires a tag to the group, the healer's own rule turns the tag into a cast
--                intent - one relay message, one reaction.
-- Tested:        The tank sends one tag; the healer's box gets exactly one cast intent and the tank's gets none.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: an in-memory relay between two boxes (in game each box's link rides the crew relay)
local bus = require("eb.relay.events").bus()
local now = 0

-- your script: one coordination engine per box, each with the rules for its own abilities
local Coord = require("eb.coord.rules")
local Link = require("eb.coord.relaylink")
local function box(id, name, role)
    local link = Link.new({ box = id, transport = bus.box(id) })
    local coord = Coord.new({ me = { box = id, name = name, role = role }, link = link, clock = function() return now end })
    link.join()                                   -- nothing is heard before join()
    local intents = {}
    coord:onIntent(function(it) intents[#intents + 1] = it end)   -- in game: hand it to the caster
    return coord, intents
end
local tank, tankIntents = box("is1", "Tankard", "tank")
local healer, healIntents = box("is2", "Mendwell", "healer")

tank:add({ id = "burn-on-shout", trigger = { kind = "cast", who = "tank", ability = "Rallying Shout" },
           action = { kind = "firetag", tag = "Burn" }, scope = "group" })
healer:add({ id = "heal-on-burn", trigger = { kind = "tag", tag = "Burn" },
             action = { kind = "cast", ability = "Fixture Mend", target = "PartyTank" }, scope = "self" })

-- the tank's box sees its own cast (in game EB's combat feeds this)
tank:feed({ kind = "cast", actor = "Tankard", name = "Tankard", role = "tank", ability = "Rallying Shout", isMe = true })
local it = healIntents[1]
print(("healer casts %s on %s (rule %s)"):format(it.ability, it.target, it.rule))

-- check
DOCS.eq(#healIntents, 1, "the healer reacts once")
DOCS.eq(#tankIntents, 0, "the tank has no reaction rule, so no intent")
DOCS.eq(it.kind, "cast", "a cast intent")
