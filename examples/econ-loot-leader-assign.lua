-- Hand drops out from the leader's loot window
--
-- On a leader window the leading box hands each drop to the member whose quota still wants it and tells that member over the crew relay; what nobody claims follows the rule or the method. eco.loot:setMethod(method) sets the group's method and, on the leader, tells the crew.
--
-- kind:      snippet
-- expect:    The shard is assigned to Healwell, the crew is told, and the method change reaches everyone.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.loot
-- id:        econ-loot-leader-assign

-- offline stand-in for the game's windows and the crew (in game EB passes its own)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({ corpse = { id = 78, name = "a fixture chest" },
    window = { mode = "leader", assignable = true, items = { { id = 1, name = "Fixture Shard" } } } })
local said = {}
local relay = {
    groupState = function() return { leader = "Fixturae",
        members = { { name = "Fixturae", subclass = "warden" }, { name = "Healwell", subclass = "templar" } } } end,
    role = function() return "tank" end,
    send = function(to, line) said[#said + 1] = to .. ": " .. line end,
}
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me, relay = relay,
    cfg = { loot = { quotas = { ["fixture shard"] = { healwell = 1 } } } } })

-- your script
DOCS.check(eco.loot:amLeader(), "this box leads the group")
local status
for _ = 1, 20 do
    status = eco.loot:lootGrab()
    if status ~= "working" then break end
end
for _, line in ipairs(W.log) do print(line) end
eco.loot:setMethod("lotto")

-- check
DOCS.eq(status, "done", "the window was handled")
DOCS.eq(said[1], "to Healwell: loot incoming: Fixture Shard", "the member is told")
DOCS.eq(said[2], "all: loot method lotto", "the new method went to the crew")
DOCS.eq(eco.env.cfg.loot.method, "lotto", "and is the setting now")
