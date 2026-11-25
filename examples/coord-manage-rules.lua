-- Keep a set of rules
--
-- Add a saved set of rules at once, look one up, switch it off and on, remove it, and list what is left - what a rules window does.
--
-- kind:      snippet
-- expect:    Three rules load; a switched-off rule does not act; the removed one is gone from the list.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.coord.rules
-- id:        coord-manage-rules

-- your script
local Coord = require("eb.coord.rules")
local coord = Coord.new({ me = { box = "is1", name = "Fixturae", role = "healer" }, clock = function() return 0 end })
local acted = 0
coord:onIntent(function() acted = acted + 1 end)
local ids = coord:addAll({
    { id = "ward-on-flames", trigger = { kind = "chat", match = "flames" },
      action = { kind = "cast", ability = "Fixture Ward" }, scope = "self" },
    { id = "hold-on-root", trigger = { kind = "chat", match = "roots you" },
      action = { kind = "embargo", ability = "Fixture Leap", durationMs = 5000 }, scope = "self" },
    { id = "crew-on-wipe", trigger = { kind = "event", event = "GroupChanged" },
      action = { kind = "crew", line = "eb all pause" }, scope = "self" },
})

coord:enable("ward-on-flames", false)
coord:feed({ kind = "chat", text = "Fixture flames rise" })
local whileOff = acted
coord:enable("ward-on-flames", true)
coord:feed({ kind = "chat", text = "Fixture flames rise" })
local afterOn = acted
local rule = coord:get("ward-on-flames")
coord:remove("ward-on-flames")
local left = {}
for _, r in ipairs(coord:all()) do left[#left + 1] = r.id end
print(("loaded %d, acted while off: %d, after on: %d, left: %s"):format(#ids, whileOff, afterOn, table.concat(left, ", ")))

-- check
DOCS.eq(rule.trigger.kind, "chat", "get answers the stored rule")
DOCS.eq(rule.action.kind, "cast", "with its action")
DOCS.eq(#left, 2, "two rules left")
DOCS.eq(coord:get("ward-on-flames"), nil, "the removed rule is gone")
