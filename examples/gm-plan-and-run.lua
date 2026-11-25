-- EB tested example: Turn Master scrolls into Grandmaster crafts
-- gm-plan-and-run | snippet | topics: items
--
-- What it does:  eco.grandmasters:plan(opts) lists each "(Master)" scroll in the bags (and, with depot = true, in the Scroll
--                Depot) whose "(Grandmaster)" recipe is in your book; run(opts) only previews until you pass go = true, because
--                every craft consumes a scroll.
-- Tested:        Three scrolls can become Grandmaster crafts (one from the Scroll Depot), one is skipped with no recipe; without
--                go nothing is made; with go all three are crafted.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: two scrolls in the bags, one in the Scroll Depot, the recipe book and a station
local CW = require("crafting.lib.craftworld")
local world = CW.world({ station = { name = "Engraved Desk" },
    bags = { { id = 1, name = "Fixture Heal IX (Master)", level = 131 }, { id = 2, name = "Fixture Smite X (Master)", level = 132 },
             { id = 3, name = "Fixture Oddity II (Master)", level = 131 } },
    depots = { scroll = { { name = "Fixture Ward XI (Master)", qty = 1 } } },
    recipes = { { name = "Fixture Heal IX (Grandmaster)" }, { name = "Fixture Smite X (Grandmaster)" },
                { name = "Fixture Ward XI (Grandmaster)" } } })
local eco = CW.economy(world)

-- your script
local Grandmasters = require("eb.economy.grandmasters")
local base, gm = Grandmasters.gmOf("Fixture Heal IX (Master)")
local plan = eco.grandmasters:plan({ depot = true })
local _, preview = eco.grandmasters:run({ depot = true })            -- no go: a preview, nothing consumed
local before = #world.made
local status = CW.poll(function() return eco.grandmasters:run({ depot = true, go = true }) end)
print(("plan: %d crafts, %d skipped; preview made %d; go made %d"):format(#plan.crafts, #plan.skipped, before, #world.made))

-- check
DOCS.eq(gm, "Fixture Heal IX (Grandmaster)", "gmOf names the Grandmaster recipe")
DOCS.eq(base, "Fixture Heal IX", "and the ability")
DOCS.eq(#plan.crafts, 3, "three scrolls can be crafted up")
DOCS.eq(plan.skipped[1].why, "no (Grandmaster) recipe in the book", "the odd one is skipped with the reason")
DOCS.eq(preview.preview, true, "without go it only previews")
DOCS.eq(status, "done", "with go the run finished")
DOCS.eq(#world.made, 3, "three Grandmaster crafts")
DOCS.eq(Grandmasters.crafterFits("sage", "templar"), true, "a sage crafts priest upgrades")
DOCS.eq(Grandmasters.crafterFits("jeweler", "templar"), false, "a jeweler does not")
