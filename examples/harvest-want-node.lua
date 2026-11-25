-- Decide which harvest nodes to take
--
-- eco.harvest:wantNode(node) is the node rule: never a blacklisted resource, never a tier above your level band (one tier per ten levels), and only the preferred categories when you set any.
--
-- kind:      snippet
-- expect:    At level 45 a tier-5 node is taken and a tier-6 one left; a blacklisted node and a node outside the preferred categories are left with their reasons.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.harvest, eb.economy
-- id:        harvest-want-node

-- offline: the economy facade with a harvest config (wantNode reads only the config and your level)
local eco = require("eb.economy").new({ drive = {}, me = { level = 45 },
    cfg = { harvest = { blacklist = { ["a fixture weed"] = true }, categories = { ore = true, wood = true } } } })

-- your script
local nodes = {
    { name = "a fixture vein", tier = 5, category = "ore" },
    { name = "a deep fixture vein", tier = 6, category = "ore" },
    { name = "a fixture weed", tier = 1, category = "root" },
    { name = "a fixture shrub", tier = 2, category = "root" },
}
local verdict = {}
for i, n in ipairs(nodes) do
    local want, why = eco.harvest:wantNode(n)
    verdict[i] = want
    print(("tier %d -> %s%s"):format(n.tier, tostring(want), why and (" (" .. why .. ")") or ""))
end

-- check
DOCS.eq(verdict[1], true, "tier 5 is inside the level-45 band")
DOCS.eq(verdict[2], false, "tier 6 is above it")
DOCS.eq(verdict[3], false, "a blacklisted resource is never taken")
DOCS.eq(verdict[4], false, "a category you did not choose is left")
