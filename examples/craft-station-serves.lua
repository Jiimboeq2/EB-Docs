-- Does this station serve the recipe?
--
-- eb.economy.craft.serves(actorName, device) answers from EB's station data whether a crafting station in reach can make a recipe's device - and never mistakes a look-alike name for the real station.
--
-- kind:      snippet
-- expect:    A forge serves a Forge recipe, a look-alike forge name and a festive bench do not, a station that serves every device always does, and an unknown device answers nil (cannot judge).
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.craft
-- id:        craft-station-serves

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
