-- Diagnose a zone's mesh
--
-- Does EB have a mesh for the zone, how many floors stack at a spot, which piece of the mesh a point is on, and the mesh's own notes and statistics - the questions a diagnostics window asks.
--
-- kind:      snippet
-- expect:    The zone has a mesh file; two floors stack at the spot; the reports read back as text.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.navd
-- id:        nav-mesh-reports

-- offline stand-in: EB's own mesh extension over a toy floor with a second storey 12 m up (in game: the zone's mesh)
local w = DOCS.world()
local fake = require("nav.lib.ebnav").attach(w, { zone = "fixture_hollow", loadFrames = 0 })

-- your script (a diagnostics window would run this once, on a command - never every frame)
local navd = require("eb.navd")
local file = navd.pathFor("fixture_hollow")
navd.ready("fixture_hollow"); w.frame(1)
local ok = navd.ready("fixture_hollow")
local floors = navd.floorsAt(5, 5, -20, 40)                -- every floor stacked at x 5, z 5
local piece = navd.pieceAt(5, 0, 5)
print(("mesh file: %s; floors at the spot: %d; piece %s"):format(tostring(file ~= nil), #floors, tostring(piece)))
local notes, stats = navd.notes(), navd.stats()
print("notes: " .. notes .. " | stats: " .. stats)

-- check
DOCS.check(file ~= nil, "EB's store has a mesh for the zone")
DOCS.eq(ok, true, "the mesh is ready")
DOCS.eq(#floors, 2, "two floors at the spot")
DOCS.near(floors[2] - floors[1], 12, 1e-6, "one storey apart")
DOCS.eq(piece, 7, "the point is on mesh piece 7")
DOCS.check(#notes > 0 and #stats > 0, "the reports read back")
