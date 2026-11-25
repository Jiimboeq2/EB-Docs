-- A short hop needs no route
--
-- A point under 10 m away whose straight line the zone's own mesh proves clear (the .nav's raycast, on this zone's loaded mesh) is walked without a route; a line the mesh cannot prove is planned like any walk.
--
-- kind:      snippet
-- expect:    The 6 m walk says "short hop", arrives, and the mesh was asked for no route at all.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.nav
-- id:        nav-short-hop

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { x = 0, y = 0, z = 0 } })
local mesh = require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })

-- your script
local nav = require("eb.nav")
local said = {}
local ok = w.task(function()
    return nav.goPoint(0, 0, 6, { onStatus = function(s) said[#said + 1] = s; print("status: " .. s) end })
end)

-- check
DOCS.eq(ok, true, "arrived")
DOCS.eq(said[1], "short hop", "walked at it as a short hop (the mesh proved the line clear)")
DOCS.eq(mesh.calls.route, 0, "no route was planned for a hop under nav.SHORT_HOP metres")
DOCS.eq(nav.SHORT_HOP, 10.0, "the short-hop distance")
