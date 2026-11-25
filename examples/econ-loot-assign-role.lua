-- Give a drop to a role: @priest, @fighter ...
--
-- An "assign" rule's "to" may name a role with @ (fighter, priest, scout, mage, a class or a subclass). On a need-or-greed window each box rolls need when it fits the role and passes when it does not.
--
-- kind:      snippet
-- expect:    The templar box needs the priest item and the guardian box passes on it.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.lootrules
-- id:        econ-loot-assign-role

-- your script
local LR = require("eb.economy.lootrules")
local d = LR.parse({ rules = { { match = "exact", item = "Fixture Censer", act = "assign", to = "@priest" } } })
local item = { { name = "Fixture Censer" } }
local healer = LR.decideWindow(d.rules, d.opts, item, "nbg", { me = "Healfixture", sub = "templar" })
local tank = LR.decideWindow(d.rules, d.opts, item, "nbg", { me = "Tankfixture", sub = "guardian" })
print(("templar: %s, guardian: %s"):format(healer.items[1].verb, tank.items[1].verb))

-- check
DOCS.eq(healer.act, "need", "the priest rolls need")
DOCS.eq(tank.items[1].verb, "pass", "the fighter passes")
DOCS.eq(LR.roleFits("priest", "templar"), true, "templar is a priest")
DOCS.eq(LR.roleFits("mage", "templar"), false, "and not a mage")
