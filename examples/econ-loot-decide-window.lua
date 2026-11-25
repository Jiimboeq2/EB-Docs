-- EB tested example: Decide what to do with a whole loot window
-- econ-loot-decide-window | snippet | topics: items, helpers, loot
--
-- What it does:  decideWindow(rules, opts, items, windowType, ctx) gives each item a verb (need, greed, pass, leave ...) and the
--                one act for the window: loot everything, loot the wanted items, or nothing.
-- Tested:        A free-for-all window where every item is wanted becomes "Loot All"; with one unwanted item only the wanted ones
--                are taken.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
