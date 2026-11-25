-- Decide what to do with a whole loot window
--
-- decideWindow(rules, opts, items, windowType, ctx) gives each item a verb (need, greed, pass, leave ...) and the one act for the window: loot everything, loot the wanted items, or nothing.
--
-- kind:      snippet
-- expect:    A free-for-all window where every item is wanted becomes "Loot All"; with one unwanted item only the wanted ones are taken.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.lootrules
-- id:        econ-loot-decide-window

-- your script
local LR = require("eb.economy.lootrules")
local d = LR.parse({ fallback = "leave", rules = {
    { match = "contains", item = "fixture", act = "greed" },
} })
local ctx = { me = "Botfixture", sub = "warden", group = {} }
local allWanted = LR.decideWindow(d.rules, d.opts,
    { { name = "a fixture pelt" }, { name = "a fixture fang" } }, LR.parseWin("Free For All"), ctx)
local oneNot = LR.decideWindow(d.rules, d.opts,
    { { name = "a fixture pelt" }, { name = "a rusty nail" } }, LR.parseWin("Free For All"), ctx)
print(("all wanted: %s; one unwanted: %s"):format(LR.actText(allWanted.act), LR.actText(oneNot.act)))

-- check
DOCS.eq(allWanted.act, "lootall", "take the lot")
DOCS.eq(oneNot.act, "lootitems", "take only the wanted ones")
DOCS.eq(oneNot.items[2].verb, "leave", "the item no rule names follows the fallback")
DOCS.eq(oneNot.lootIdx[1], 1, "the index of the wanted item")
