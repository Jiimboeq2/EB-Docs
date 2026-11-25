-- EB tested example: Does this station serve the recipe?
-- craft-station-serves | snippet | topics: items, helpers
--
-- What it does:  eb.economy.craft.serves(actorName, device) answers from EB's station data whether a crafting station in reach
--                can make a recipe's device - and never mistakes a look-alike name for the real station.
-- Tested:        A forge serves a Forge recipe, a look-alike forge name and a festive bench do not, a station that serves every
--                device always does, and an unknown device answers nil (cannot judge).
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script (pure: no game reads)
local Craft = require("eb.economy.craft")
local checks = {
    { "Forge", "Forge" },                               -- the station itself
    { "Sootfoot Forge", "Forge" },                      -- an NPC whose name only holds "forge"
    { "A Festive Work Bench", "Work Bench" },           -- a decoration, not a bench
    { "Rickety Crafting Table", "Chemistry Table" },    -- serves every device
    { "Forge", "a device nobody has heard of" },
}
for _, c in ipairs(checks) do print(("%s -> %s"):format(c[1], tostring(Craft.serves(c[1], c[2])))) end

-- check
DOCS.eq(Craft.serves("Forge", "Forge"), true, "the forge serves forge recipes")
DOCS.eq(Craft.serves("Sootfoot Forge", "Forge"), false, "a name that only holds 'forge' is no forge")
DOCS.eq(Craft.serves("A Festive Work Bench", "Work Bench"), false, "the festive bench is not a work bench")
DOCS.eq(Craft.serves("Rickety Crafting Table", "Chemistry Table"), true, "an any-device station serves it")
DOCS.eq(Craft.serves("Forge", "a device nobody has heard of"), nil, "an unknown device cannot be judged")
