-- Run a bulk salvage - and the guards that refuse a careless one
--
-- eco.transmute:tse(pick) transmutes, salvages, extracts or destroys the items a pick selects, each through the safety rules. A pick that does not say what goes is refused before anything is touched; dry = true only previews; a destroy without go = true only previews too.
--
-- kind:      snippet
-- expect:    An empty pick is refused, a destroy without go only previews, and the salvage of treasured items up to level 50 takes the two that may go and keeps the heirloom.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.transmute, eb.economy
-- id:        transmute-bulk-run

-- offline stand-in: three treasured bag items
local CW = require("crafting.lib.craftworld")
local world = CW.world({ bags = {
    { id = 1, name = "Fixture Ring", rarity = "TREASURED", tier = "TREASURED", type = "Ring", ilvl = 40 },
    { id = 2, name = "Fixture Gloves", rarity = "TREASURED", tier = "TREASURED", type = "Gloves", ilvl = 42 },
    { id = 3, name = "Fixture Cape", rarity = "TREASURED", tier = "TREASURED", type = "Cape", ilvl = 45, heirloom = true } } })
local eco = CW.economy(world)

-- your script
local refused, why = eco.transmute:tse({})                                     -- "everything": refused
local dry, preview = eco.transmute:tse({ action = "destroy", tiers = { TREASURED = true } })   -- no go: a preview
print("empty pick -> " .. refused .. " (" .. why .. "); destroy without go -> " .. dry .. ", would take " .. #preview.taken)

local pick = { action = "salvage", tiers = { TREASURED = true }, maxLevel = 50 }
local status = CW.poll(function() return eco.transmute:tse(pick) end)
print(("salvage -> %s, %d item left in the bags"):format(status, #world.bags))

-- check
DOCS.eq(refused, "blocked", "a pick that names nothing is refused")
DOCS.eq(preview.preview, true, "a destroy without go only previews")
DOCS.eq(status, "done", "the salvage ran")
DOCS.eq(#world.bags, 1, "two salvaged")
DOCS.eq(world.bags[1].name, "Fixture Cape", "the heirloom stayed")
