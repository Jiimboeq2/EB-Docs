-- Snapshot a character's gear for a group decision
--
-- gearexport.snapshot reads worn gear, bags and bank through a host and builds the gear export the group loot auction and gear matching compare. Bags keep only what can be worn or is Lore, a ring's slot family becomes every ring slot, and the result is rebuilt from a field whitelist so nothing else a host attaches survives.
--
-- kind:      snippet
-- expect:    The worn piece keeps its slot, the bag ring fits both fingers, the junk is dropped and a stray field is gone.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.exports.gearexport
-- id:        export-gear-snapshot

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
