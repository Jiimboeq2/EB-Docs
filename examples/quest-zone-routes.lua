-- EB tested example: A pack's own way into a zone
-- quest-zone-routes | snippet | topics: quests, nav
--
-- What it does:  zone_routes names how this pack gets into a zone: each way is a list of steps run as a sub-sequence when
--                CheckZone needs that zone. A way that fails moves on to the next; only when every written way is spent does
--                CheckZone hand the zone to the zone's allowed transit.
-- Tested:        The first way's ride fails, the second way (walk to the bell, ring it) is taken, and the pack arrives without a
--                need_travel.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local PACK = {
    schema = "eb-quest/1", quest_name = "Fixture Crossing",
    zone_routes = {
        ["Fixture Vale"] = {
            { why = "via the ferry", steps = { { type = "command", command = 'Transit "Vale Landing | a fixture ferryman"' } } },
            { why = "via the pier bell", steps = {
                { type = "command", command = "MM 30,0,5" },
                { type = "command", command = 'TravelBell "Fixture Vale"' } } },
        },
    },
    steps = { { type = "command", command = 'CheckZone "Fixture Vale"' } },
}
local deps, world = require("quests.lib.questworld").make({ zone = "Fixture Docks" })
deps.act.transit = function() return "blocked", "the ferry is not running" end    -- the first way fails
local quests = require("eb.quest").bind(deps)
local run = quests.start({ quest = PACK, name = PACK.quest_name }, {})

local trace, status, info = {}, nil, nil
for _ = 1, 40 do
    status, info = quests.step(run)
    trace[#trace + 1] = status
    if status == "working" and tostring(info):find("running route", 1, true) then print(info) end
    if status == "need_travel" then deps.nav.travelTo(info, { pack = true }) end   -- the bell's ride
    if status == "complete" or status == "blocked" then break end
    world.tick(5000)
end

DOCS.eq(status, "complete", "in the zone")
DOCS.eq(world.zone, "Fixture Vale", "arrived")
DOCS.eq(world.did("walk"), 1, "walked to the bell (the second way's first step)")
