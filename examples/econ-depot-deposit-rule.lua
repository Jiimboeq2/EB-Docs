-- Deposit by a rule, keep the keep list
--
-- eco.depot:deposit() moves NOTHING without a rule - a list, an opts.only predicate, a filter in cfg.depot.depositRule, or all = true. Whatever the rule picks, the keep list (cfg.depot.keep) and every protected item stay in the bags; each item goes to its own depot kind.
--
-- kind:      snippet
-- expect:    With no rule it refuses; with a rule for ore the ore goes to the harvest depot and the kept arrows stay.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.depot, eb.economy.filter
-- id:        econ-depot-deposit-rule

-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({
    bags = { { name = "Fixture Ore", qty = 30 }, { name = "Fixture Arrow", qty = 200 }, { name = "Fixture Charm" } },
    depots = { harvest = {}, ammo = {} },
})
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me,
    cfg = { depot = { keep = { ["fixture arrow"] = true } }, protect = { names = { ["fixture charm"] = true } } } })

-- your script, part 1: no rule -> refused, nothing deposited
local s0, why0 = eco.depot:deposit()
DOCS.eq(s0, "blocked", "no rule, no deposit")
DOCS.has(why0, "no deposit rule", "the reason")

-- part 2: a rule - everything with "Ore" or "Arrow" in its name (the arrows are on the keep list anyway)
local status
for _ = 1, 20 do
    status = eco.depot:deposit(nil, { only = function(it) return it.name:find("Ore") or it.name:find("Arrow") end })
    if status ~= "working" then break end
end
for _, line in ipairs(W.log) do print(line) end

-- check
DOCS.eq(status, "done", "the deposit finished")
DOCS.eq(W.depots.harvest.contents["Fixture Ore"], 30, "the ore is in the harvest depot")
DOCS.eq(W.depots.ammo.contents["Fixture Arrow"], nil, "the kept arrows were not deposited")
DOCS.eq(#W.bags, 2, "arrows and the protected charm stay in the bags")
