-- EB tested example: Plan who in the group should get which spare piece
-- gear-group-trades | snippet | topics: items, crew
--
-- What it does:  eco.gearup:planGroupTrades(exports) reads every box's worn gear and spare bag pieces and plans each trade to
--                whoever it upgrades most (never a no-trade or heirloom piece). groupMatch(exports, opts) carries the plan out;
--                with opts.planOnly it only answers the plan.
-- Tested:        The priest's spare robe goes to the other priest it upgrades; the tank's spare plate is best on the tank itself,
--                so it is not traded; the heirloom is never planned.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
