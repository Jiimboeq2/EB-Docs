-- Economy settings and their safe defaults
--
-- rules.load(userCfg) lays your settings over safe defaults: nothing is sold or destroyed until you turn it on. rules.whoApplies(who, me) reads a row's "for" word (everyone, a class, an archetype).
--
-- kind:      snippet
-- expect:    Your threshold replaces the default while everything you did not set keeps its safe default.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.rules
-- id:        econ-rules-config

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
