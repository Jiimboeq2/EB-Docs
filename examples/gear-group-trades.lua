-- Plan who in the group should get which spare piece
--
-- eco.gearup:planGroupTrades(exports) reads every box's worn gear and spare bag pieces and plans each trade to whoever it upgrades most (never a no-trade or heirloom piece). groupMatch(exports, opts) carries the plan out; with opts.planOnly it only answers the plan.
--
-- kind:      snippet
-- expect:    The priest's spare robe goes to the other priest it upgrades; the tank's spare plate is best on the tank itself, so it is not traded; the heirloom is never planned.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.gearup, eb.economy
-- id:        gear-group-trades

-- offline: three boxes' exports (in game each box sends its own over the crew relay)
local eco = require("eb.economy").new({ drive = {}, me = { name = "Fixturae", subclass = "templar" } })
local exports = {
    Tankard = { role = "fighter", worn = { chest = { stats = { stamina = 10 } } },
                bags = { { name = "Fixture Plate", slot = "chest", stats = { stamina = 50 } } } },
    Fixturae = { role = "priest", worn = { chest = { stats = { wisdom = 40 } } },
                 bags = { { name = "Fixture Robe", slot = "chest", stats = { wisdom = 20 } },
                          { name = "Fixture Heirloom Robe", slot = "chest", stats = { wisdom = 99 }, heirloom = true } } },
    Healio = { role = "priest", worn = { chest = { stats = { wisdom = 5 } } }, bags = {} },
}

-- your script
local plan = eco.gearup:groupMatch(exports, { planOnly = true })
for _, p in ipairs(plan) do print(("%s: %s -> %s (gain %.0f)"):format(p.item.name, p.from, p.to, p.gain)) end

-- check
DOCS.eq(#plan, 1, "one trade planned")
DOCS.eq(plan[1].to, "Healio", "the robe goes where it upgrades most")
DOCS.eq(plan[1].from, "Fixturae", "from the box that holds it")
