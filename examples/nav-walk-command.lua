-- Walk with an eb command
--
-- The same walk as a console line: eb walk x,y,z goes through the command registry, starts the walk on the pulse and answers at once.
--
-- kind:      snippet
-- expect:    The command answers "issued" at once; a few seconds later the walk has arrived; eb route previews a trip.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.registry, eb.nav_register, eb.nav
-- id:        nav-walk-command

-- offline stand-in for the game (only the docs runner has DOCS; in game EB wires the commands at start)
local w = DOCS.world({ me = { x = 0, y = 0, z = 0 } })
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })
local reg = w.registry()
require("eb.nav_register").wire(reg, {})            -- EB's start does this once for every box

-- your script
local ok, text = reg:dispatch("eb walk 20,0,15")    -- never blocks: the walk runs on the pulse
print("walk: " .. tostring(text))
w.runFor(6000)
local nav = require("eb.nav")
print("last walk ok: " .. tostring(nav.last and nav.last.ok))

-- check
DOCS.eq(ok, true, "the command was accepted")
DOCS.has(text, "issued", "and answered at once")
DOCS.eq(nav.last and nav.last.ok, true, "the walk arrived")
DOCS.check(math.sqrt((w.self.x - 20) ^ 2 + (w.self.z - 15) ^ 2) <= 2.5, "where the command said")
local bad, why = reg:dispatch("eb walk")
DOCS.eq(bad, false, "a walk with no point is refused")
DOCS.has(why, "x,y,z", "and says what it needs")
