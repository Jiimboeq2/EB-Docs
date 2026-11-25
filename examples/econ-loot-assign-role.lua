-- EB tested example: Give a drop to a role: @priest, @fighter ...
-- econ-loot-assign-role | snippet | topics: items, crew, loot
--
-- What it does:  An "assign" rule's "to" may name a role with @ (fighter, priest, scout, mage, a class or a subclass). On a
--                need-or-greed window each box rolls need when it fits the role and passes when it does not.
-- Tested:        The templar box needs the priest item and the guardian box passes on it.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
