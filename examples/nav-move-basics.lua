-- Face a point and hold a key
--
-- eb.move is the low-level mover the walker uses: read where you stand and face, turn to a point, hold forward, stop.
--
-- kind:      snippet
-- expect:    Facing +X reads heading 90; a second of forward moves you about 7 m along it; stop() lets every key go.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.move
-- id:        nav-move-basics

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { x = 0, y = 0, z = 0 } })
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })

-- your script
local move = require("eb.move")
print(("heading to 10,0: %.0f"):format(move.headingTo(10, 0)))   -- EB's headings: 0 = +Z, 90 = +X
move.face(10, 0)                                                   -- turn to the point (the game ignores Y)
w.frame(2)
local x0 = move.pos()
move.forwardOn(true)                                               -- sent once; held until released
w.runFor(1000)
move.stop()                                                        -- let go of every movement key
w.frame(2)
local x1, _, z1 = move.pos()
print(("moved %.1f m along +X"):format(x1 - x0))

-- check
DOCS.near(move.heading(), 90, 1, "facing +X")
DOCS.check(x1 - x0 > 5 and x1 - x0 < 9, "about one second of running")
DOCS.near(z1, 0, 0.5, "straight along the heading")
DOCS.check(not move.held("forward"), "forward is released")
DOCS.near(move.turnDelta(350, 10), 20, 1e-6, "turnDelta: the shortest signed turn")
