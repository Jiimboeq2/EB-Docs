-- EB tested example: Class facts fill in what a heal row leaves out
-- stack-class-facts | snippet | topics: combat, data
--
-- What it does:  A row says when and on whom; it does not say whether a heal is a single or a group spell. With no class facts EB
--                builds the row from its own Target, % and # (a single-target heal at the default weight); with the class's facts
--                the same row builds as the group heal it is.
-- Tested:        Without facts the heal row builds from the row alone, as a single-target heal; with the templar's facts it
--                builds as a group heal. Nothing is held either way.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local JS = require("eb.caststack.jsonstack")
local CF = require("eb.caststack.classfacts")
local function profile()
    return { castStack = { { slot = 1, name = "Word of Redemption", ability = "Word of Redemption", type = "Heal",
                             target = "@Group", disabled = false, cond = {} } } }
end
local bare = JS.build(profile(), { class = "templar" })
local facts = assert(CF.forClass("templar"))           -- cached: the same table every call
local full = JS.build(profile(), { class = "templar", facts = facts })
print(("without facts: %s; with facts: %s"):format(bare.entries[1].def.type, full.entries[1].def.type))
print("with facts: held " .. #full.held .. ", type " .. tostring(full.entries[1].def.type))

-- check
DOCS.eq(#bare.held, 0, "no facts: the row is built from its own words, not held")
DOCS.eq(bare.entries[1].def.type, "SINGLE_BASIC", "as a single-target heal: the row alone cannot say it is a group spell")
DOCS.eq(#full.held, 0, "with facts it builds")
DOCS.eq(full.entries[1].def.type, "GROUP_HEAL", "as a group heal")
DOCS.check(#CF.classes() > 20, "EB ships facts for every class")
DOCS.eq(CF.forClass("no such class"), nil, "an unknown class has none")
