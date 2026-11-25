-- EB tested example: Strip old gear's adornments, keep temporary adornments up
-- adorn-unadorn-and-temp | snippet | topics: items
--
-- What it does:  eco.adornments:unadorn{ tiers } takes the adornments off bag items of those tiers (a protected item is never
--                touched); tempAdorns(profile, { active = fn(slot) }) re-applies only the slots whose temporary adornment is no
--                longer on.
-- Tested:        The old vest's rune comes back into the bags and the protected treasure keeps its adornment; with the chest's
--                temporary adornment still on, only the legs are applied; with every slot on, nothing is done.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: two adorned bag items, worn gear for the temp profile and its adornments in the bags
local CW = require("crafting.lib.craftworld")
local world = CW.world({
    bags = { { id = 20, name = "Fixture Old Vest", rarity = "FABLED", adorns = { { slot = "white", name = "Fixture Rune" } } },
             { id = 21, name = "a personal treasure of fixtures", rarity = "FABLED", adorns = { { slot = "white", name = "Fixture Gem" } } },
             { id = 30, name = "Fixture Spark" } },
    worn = { chest = { id = 50, name = "Fixture Vest" }, legs = { id = 51, name = "Fixture Greaves" } } })
local eco = CW.economy(world)

-- your script
local stripped = CW.poll(function() return eco.adornments:unadorn({ tiers = { FABLED = true } }) end)
local temp = { chest = "Fixture Flare", legs = "Fixture Spark" }
local still = CW.poll(function()
    return eco.adornments:tempAdorns(temp, { active = function(slot) return slot == "chest" end })
end)
local allOn = eco.adornments:tempAdorns(temp, { active = function() return true end })
print(("unadorn -> %s; temp -> %s"):format(stripped, world.worn.legs.adorns and "legs only" or "none"))

-- check
DOCS.eq(#world.bags[1].adorns, 0, "the old vest was stripped")
DOCS.check(eco.adornments:adornInBags("Fixture Rune") ~= nil, "its rune is back in the bags")
DOCS.eq(#world.bags[2].adorns, 1, "the protected treasure was not touched")
DOCS.eq(still, "done", "the temp run finished")
DOCS.eq(world.worn.chest.adorns, nil, "the still-active chest was left alone")
DOCS.eq(allOn, "done", "every slot still on: nothing to do")
