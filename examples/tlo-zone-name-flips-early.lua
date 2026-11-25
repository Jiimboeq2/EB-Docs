-- Zone.Name changes at the START of a zone load
--
-- ${Zone.Name} names the NEW zone as soon as the load begins, while the zone is not playable yet. Wait for EQ2.Zoning to read 0 (game.Zoning() false) before you act on the new zone.
--
-- kind:      snippet
-- expect:    During the load the zone name is already new but Zoning is not 0; the helper acts only after the load ends.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        tlo-zone-name-flips-early

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
