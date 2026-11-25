-- A pack's own way into a zone
--
-- zone_routes names how this pack gets into a zone: each way is a list of steps run as a sub-sequence when CheckZone needs that zone. A way that fails moves on to the next; only when every written way is spent does CheckZone hand the zone to the zone's allowed transit.
--
-- kind:      snippet
-- expect:    The first way's ride fails, the second way (walk to the bell, ring it) is taken, and the pack arrives without a need_travel.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.quest
-- id:        quest-zone-routes

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
