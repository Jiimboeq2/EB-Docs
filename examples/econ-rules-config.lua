-- EB tested example: Economy settings and their safe defaults
-- econ-rules-config | snippet | topics: items, data
--
-- What it does:  rules.load(userCfg) lays your settings over safe defaults: nothing is sold or destroyed until you turn it on.
--                rules.whoApplies(who, me) reads a row's "for" word (everyone, a class, an archetype).
-- Tested:        Your threshold replaces the default while everything you did not set keeps its safe default.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local R = require("eb.economy.rules")
local cfg = R.load({ bags = { fullThreshold = 5 } })
print(("bags full at %d free; sell junk: %s; repair below %d%%"):format(cfg.bags.fullThreshold,
    tostring(cfg.vendor.sellJunk), cfg.vendor.repairBelowPct))

-- check
DOCS.eq(cfg.bags.fullThreshold, 5, "your setting")
DOCS.eq(cfg.vendor.sellJunk, false, "selling junk stays off until you turn it on")
DOCS.eq(R.whoApplies("priest", { subclass = "templar" }), true, "a templar is a priest")
DOCS.eq(R.whoApplies("fighter", { subclass = "templar" }), false, "and not a fighter")
DOCS.eq(R.archetypeOf("Shadow Knight"), "fighter", "any spelling of a subclass")
