-- What this box does with each drop
--
-- eco.loot:classify(item) is the simple per-drop rule: a rule for the item's name first (cfg.loot.rules), then the always-take list (cfg.loot.autoTake), then a quota a group member still wants (cfg.loot.quotas, counted against cfg.loot.owned), then the group's loot method. A full loot-rules document (cfg.loot.rulesDoc, see eb.economy.lootrules) replaces this path when it is on.
--
-- kind:      snippet
-- expect:    need for the gem, take for the pouch, to:Tankard for the shard, greed for the rest (need before greed).
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.loot
-- id:        econ-loot-classify

-- offline stand-in for the game's windows and the crew (in game EB passes its own)
local Fake = require("economy.lib.drivefake")
local W = Fake.world()
local relay = { groupState = function() return { leader = "Tankard",
    members = { { name = "Tankard", subclass = "guardian" }, { name = "Fixturae", subclass = "warden" } } } end,
    role = function() return "member" end, send = function() end }

-- your script
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me, relay = relay, cfg = { loot = {
    rules = { ["fixture gem"] = "need" },
    autoTake = { "Fixture Coin Pouch" },
    quotas = { ["fixture shard"] = { tankard = 2 } },        -- the tank wants two shards ...
    owned = { Tankard = { ["fixture shard"] = 1 } },         -- ... and holds one
    method = "nbg",
} } })
local loot = eco.loot
print("shard: " .. loot:classify({ name = "Fixture Shard" }))

-- check
DOCS.eq(loot:classify({ name = "Fixture Gem" }), "need", "a name rule first")
DOCS.eq(loot:classify({ name = "Fixture Coin Pouch" }), "take", "the always-take list")
DOCS.eq(loot:classify({ name = "Fixture Shard" }), "to:Tankard", "a member's quota")
DOCS.eq(loot:classify({ name = "Fixture Rag" }), "greed", "need before greed: greed by default")
DOCS.eq(#loot:roster(), 2, "the roster comes from the crew's group state")
DOCS.check(not loot:amLeader(), "this box is not the group's leader")
