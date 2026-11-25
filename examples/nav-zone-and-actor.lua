-- EB tested example: Where am I, and where is that actor
-- nav-zone-and-actor | snippet | topics: nav, game, helpers
--
-- What it does:  eb.zone gives the short zone name the mesh and the travel network are keyed by; eb.actor.locOf finds a named
--                actor's position.
-- Tested:        The zone reads fixture_hollow; the lamplighter is found at its place; a name that is not there answers nil.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow", zoneName = "Fixture Hollow" })
w.addActor({ id = 610, name = "a fixture lamplighter", type = "NPC", x = -12, y = 0, z = 30 })

-- your script
local zone = require("eb.zone")
local actor = require("eb.actor")
print("zone " .. tostring(zone.shortName()) .. ", in the world: " .. tostring(zone.inWorld()))
local x, y, z = actor.locOf("A Fixture Lamplighter")    -- exact name, any case
print(("lamplighter at %.0f, %.0f, %.0f"):format(x, y, z))
local gone = actor.locOf("a fixture ghost")

-- check
DOCS.eq(zone.shortName(), "fixture_hollow", "the short zone name")
DOCS.eq(zone.inWorld(), true, "in the world")
DOCS.near(x, -12, 1e-6, "x"); DOCS.near(z, 30, 1e-6, "z")
DOCS.eq(gone, nil, "an actor that is not here answers nil")
