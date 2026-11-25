-- EB tested example: Keep a set of rules
-- coord-manage-rules | snippet | topics: crew, data
--
-- What it does:  Add a saved set of rules at once, look one up, switch it off and on, remove it, and list what is left - what a
--                rules window does.
-- Tested:        Three rules load; a switched-off rule does not act; the removed one is gone from the list.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
