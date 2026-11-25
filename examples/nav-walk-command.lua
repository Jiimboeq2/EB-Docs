-- EB tested example: Walk with an eb command
-- nav-walk-command | snippet | topics: nav, commands
--
-- What it does:  The same walk as a console line: eb walk x,y,z goes through the command registry, starts the walk on the pulse
--                and answers at once.
-- Tested:        The command answers "issued" at once; a few seconds later the walk has arrived; eb route previews a trip.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
