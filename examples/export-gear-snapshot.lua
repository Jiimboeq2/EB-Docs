-- EB tested example: Snapshot a character's gear for a group decision
-- export-gear-snapshot | snippet | topics: items, crew
--
-- What it does:  gearexport.snapshot reads worn gear, bags and bank through a host and builds the gear export the group loot
--                auction and gear matching compare. Bags keep only what can be worn or is Lore, a ring's slot family becomes
--                every ring slot, and the result is rebuilt from a field whitelist so nothing else a host attaches survives.
-- Tested:        The worn piece keeps its slot, the bag ring fits both fingers, the junk is dropped and a stray field is gone.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local gearexport = require("eb.exports.gearexport")

-- a host over the game's item reads (offline: invented items)
local host = {
    identity = function() return { name = "Fixturae", class = "warrior", subClass = "guardian", level = 100 } end,
    worn = function() return { chest = { name = "a fixture breastplate", stats = { stamina = 120 }, guildTag = "x" } } end,
    bags = function() return { { name = "a fixture ring", slot = "ring", stats = { agility = 30 } },
                              { name = "a fixture rag" } } end,
}

-- your script
local export, info = gearexport.snapshot({ host = host, includeBank = false })
local ring = export.bags[1]
print(("worn %d, bags %d (the ring fits %s)"):format(info.worn, info.bags, table.concat(ring.slots, " + ")))
local item = gearexport.normalizeItem({ name = "a fixture charm", slot = "charm", lore = true })

-- check
DOCS.check(export.worn.chest ~= nil, "the worn piece is kept by its slot")
DOCS.eq(export.worn.chest.guildTag, nil, "a field off the whitelist is gone")
DOCS.eq(#ring.slots, 2, "a ring competes for both fingers")
DOCS.eq(info.bags, 1, "the rag that cannot be worn is dropped")
DOCS.eq(export.archetype, "fighter", "the archetype comes from the subclass")
DOCS.eq(item.lore, true, "normalizeItem keeps the Lore flag")
