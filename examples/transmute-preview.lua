-- EB tested example: Preview what a bulk transmute would take
-- transmute-preview | snippet | topics: items
--
-- What it does:  eco.transmute:preview(pick) lists the bag items a run WOULD take and every other item in the bags with the
--                reason it stays: protected, a Master or better scroll, a bound item you did not opt in, an item whose details
--                never read, an item outside the pick's tiers or levels.
-- Tested:        Of the treasured items up to level 50 only the ring is taken; the other six stay, each with its reason: the
--                heirloom cape, the master scroll, the unread charm, the personal treasure, and the legendary blade and the
--                level-70 boots that are outside the pick.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: a few bag items (rarity = the item's tier word; type Unknown = its details never read)
local CW = require("crafting.lib.craftworld")
local world = CW.world({ bags = {
    { id = 1, name = "Fixture Ring", rarity = "TREASURED", tier = "TREASURED", type = "Ring", ilvl = 40 },
    { id = 2, name = "Fixture Cape", rarity = "TREASURED", tier = "TREASURED", type = "Cape", ilvl = 45, heirloom = true },
    { id = 3, name = "Fixture Strike IV (Master)", rarity = "TREASURED", tier = "TREASURED", type = "Scroll", ilvl = 30 },
    { id = 4, name = "Fixture Charm", rarity = "TREASURED", tier = "TREASURED", type = "Unknown", ilvl = 35 },
    { id = 5, name = "a personal treasure of fixtures", rarity = "TREASURED", tier = "TREASURED", type = "Item", ilvl = 20 },
    { id = 6, name = "Fixture Blade", rarity = "LEGENDARY", tier = "LEGENDARY", type = "Weapon", ilvl = 40 },
    { id = 7, name = "Fixture Boots", rarity = "TREASURED", tier = "TREASURED", type = "Boots", ilvl = 70 } } })
local eco = CW.economy(world)

-- your script: treasured items, item level up to 50
local taken, kept = eco.transmute:preview({ action = "transmute", tiers = { TREASURED = true }, maxLevel = 50 })
for _, it in ipairs(taken) do print("take: " .. it.name) end
for _, k in ipairs(kept) do print(("keep: %s (%s)"):format(k.item.name, k.why)) end

-- check
DOCS.eq(#taken, 1, "only the ring goes")
DOCS.eq(taken[1].name, "Fixture Ring", "the ring")
DOCS.eq(#kept, 6, "the other six are kept, each with a reason")
local why = {}
for _, k in ipairs(kept) do why[k.item.name] = k.why end
DOCS.has(why["Fixture Cape"], "not opted in", "the bound cape: you did not opt in")
DOCS.has(why["Fixture Strike IV (Master)"], "scroll", "a Master spell scroll is kept")
DOCS.has(why["Fixture Charm"], "unread", "the charm's details never read")
DOCS.has(why["a personal treasure of fixtures"], "protected", "the personal treasure is protected")
DOCS.has(why["Fixture Blade"], "tier", "the legendary blade is outside the pick's tiers")
DOCS.has(why["Fixture Boots"], "level", "the level-70 boots are outside the level band")
DOCS.eq(#world.bags, 7, "a preview touches nothing")
