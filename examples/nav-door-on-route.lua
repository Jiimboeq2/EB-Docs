-- Open the door a route goes through
--
-- The zone's door lines say where its doors are and the verb each takes; nav.tryDoor clicks the known door in reach through nav.doorDeps, never a teleporter, and never the same door twice in a few seconds.
--
-- kind:      snippet
-- expect:    The gate 2 m away is clicked with its own verb; a second try at once is refused; the teleporter is vetoed.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.nav, eb.nav_doors, eb.nav_store
-- id:        nav-door-on-route

-- offline stand-in for the game and its mesh, with EB's nav data kept in memory (in game: EB's mesh store)
local w = DOCS.world({ me = { x = 8, y = 0, z = 5 } })
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })
local store = require("eb.nav_store")
store.writeText(store.storePath(store.join(store.DOORS, "fixture_hollow.txt")),
    "# fixture_hollow doors -- x y z verb name\n" ..
    "10.00\t0.00\t5.00\topen\ta fixture gate\n" ..
    "40.00\t0.00\t5.00\t\ta fixture portal\n")
store.writeText(store.storePath(store.GATES), "T\ta fixture portal\n")    -- a teleporter: never clicked by a walk

-- your script
local nav, doors = require("eb.nav"), require("eb.nav_doors")
local clicks = {}
nav.doorDeps = { click = function(door, verb, attempt)                    -- in game EB wires the game's own clicker
    clicks[#clicks + 1] = door.name .. " / " .. verb .. " / try " .. attempt
    return true
end }
for _, d in ipairs(doors.forZone("fixture_hollow")) do
    print(("door '%s' at %.0f,%.0f: verb %s (%s)"):format(d.name, d.x, d.z, tostring(d.clickVerb), d.src))
end
local trip = {}                                           -- one walk's record of the doors it tried
local ok, what = nav.tryDoor(8, 0, 5, 6, trip)
print(what)
local again, why = nav.tryDoor(8, 0, 5, 6, trip)          -- the same door moments later
print("again: " .. tostring(why))

-- check
DOCS.eq(ok, true, "the gate was clicked")
DOCS.eq(clicks[1], "a fixture gate / open / try 1", "with its own verb, first try")
DOCS.eq(again, false, "a door clicked moments ago is not clicked again")
DOCS.has(why, "moments ago", "and the walk says why")
DOCS.eq(doors.gateKind("a fixture portal"), "T", "the portal is listed as a teleporter")
DOCS.eq(doors.vetoed("a fixture portal"), true, "so a walk never clicks it")
DOCS.eq(#clicks, 1, "one click in all")
