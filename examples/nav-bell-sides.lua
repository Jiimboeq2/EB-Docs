-- EB tested example: Which side of the city bells you travel on
-- nav-bell-sides | snippet | topics: nav, helpers
--
-- What it does:  A character's side comes from its bind city, else what its guild hall globe showed, else the setting; city bell
--                rides never cross sides, and a trip into the other side's city stops with the reason.
-- Tested:        A character bound in the good city is good; a bell ride into the evil city is refused; a globe read decides for
--                a character bound nowhere.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: the cities' sides as data (in game: EB's own travel data)
local w = DOCS.world()
local side = require("eb.nav_side")
side.load({ zones = { ["Fixture Keep"] = "good", ["Fixture Gloom"] = "evil" },
            stops = { ["Fixture Keep Docks"] = { lands_in = "Fixture Keep", side = "ungated" } } }, true)

-- your script
local mine, from = side.resolve({ bind = "Fixture Keep" })
print(("side: %s (%s)"):format(mine, from))
local ride, why = side.edgeAllowed(mine, "Fixture Hollow", "Fixture Gloom")
local stop, reason = side.otherSide(mine, "Fixture Gloom")
local globe = side.sideOfMap({ "Qeynos Province District", "Fixture Hollow" })  -- a hall globe's buttons (the game's own city)
local unbound = side.resolve({ bind = "None", globe = globe })

-- check
DOCS.eq(mine, "good", "bound in the good city")
DOCS.eq(ride, false, "a bell ride into the evil city does not exist for this character")
DOCS.has(why, "good side", "and it says why")
DOCS.eq(stop, true, "a trip ending there stops")
DOCS.eq(side.landsIn("Fixture Keep Docks"), "Fixture Keep", "a menu stop lands in its zone")
DOCS.eq(unbound, "good", "a character bound nowhere takes the globe's side")
DOCS.eq(side.whoKey(mine, "Fixture Keep"), "side:good", "bell maps are kept per side")
