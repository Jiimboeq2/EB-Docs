-- EB tested example: Zone.Name changes at the START of a zone load
-- tlo-zone-name-flips-early | snippet | topics: tlos, nav, helpers
--
-- What it does:  ${Zone.Name} names the NEW zone as soon as the load begins, while the zone is not playable yet. Wait for
--                EQ2.Zoning to read 0 (game.Zoning() false) before you act on the new zone.
-- Tested:        During the load the zone name is already new but Zoning is not 0; the helper acts only after the load ends.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.self.zone = "a test hall"
w.world.zoning, w.world.zoneName = true, "a fixture vale"          -- the load has just started

-- your script
local raw = IS.Parse("${Zone.Name}|${EQ2.Zoning}")
local zone, zoning = raw:match("^([^|]*)|([^|]*)$")
if tonumber(zoning) ~= 0 then print(("loading %s (Zoning %s): wait"):format(zone, zoning)) end
local game = require("eb.platform").game()
local actedEarly = not game.Zoning()
w.world.zoning = false                                              -- the load ends
game.BeginTick()

-- check
DOCS.eq(zone, "a fixture vale", "the name is already the new zone")
DOCS.eq(actedEarly, false, "game.Zoning() held the helper during the load")
DOCS.eq(game.Zoning(), false, "and lets it go once the load is over")
DOCS.eq(IS.Parse("${Zone.ShortName}"), "afixturevale", "ShortName is the zone's short key")
