-- EB tested example: Marks and blacklists from the console
-- nav-marks-command | snippet | topics: nav, commands
--
-- What it does:  eb marks set / list / go / del keep named spots, and eb bl / eb gl blacklist or greenlight the spot you stand on
--                - the same work eb.nav_marks and eb.nav_places do, as console lines a script can send.
-- Tested:        The mark is set and listed, eb marks go walks back to it, eb bl puts a circle where you stand, eb gl lifts it.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game EB wires the commands at start)
local w = DOCS.world({ me = { x = 4, y = 0, z = 4 } })
require("nav.lib.navworld").attach(w, { zone = "fixture_hollow" })
local reg = w.registry()
require("eb.nav_register").wire(reg, {})

-- your script
local okSet, setText = reg:dispatch("eb marks set camp")
print("marks set: " .. tostring(setText))
local _, listText = reg:dispatch("eb marks list")
w.self.x, w.self.z = 30, 30                             -- you walked off (offline: the world moves you)
local okGo, goText = reg:dispatch("eb marks go camp")  -- a walk back, on the pulse
w.runFor(6000)
local backAt = math.sqrt((w.self.x - 4) ^ 2 + (w.self.z - 4) ^ 2)
local okBl = reg:dispatch("eb bl add 5")                -- a 5 m circle where you stand
local circles = #require("eb.nav_places").listBlacklist("fixture_hollow")
local okGl = reg:dispatch("eb gl add")                  -- greenlight the same spot
local inForce = #require("eb.nav_places").avoidCircles("fixture_hollow")
reg:dispatch("eb marks del camp")

-- check
DOCS.eq(okSet, true, "eb marks set")
DOCS.has(listText, "camp", "eb marks list shows it")
DOCS.has(goText, "issued", "eb marks go answers at once")
DOCS.check(backAt <= 2.5, "and walked back to the mark")
DOCS.eq(okBl, true, "eb bl")
DOCS.eq(circles, 1, "one blacklist circle where you stand")
DOCS.eq(okGl, true, "eb gl")
DOCS.eq(inForce, 0, "the greenlight lifts it")
DOCS.eq(require("eb.nav_marks").get("camp"), nil, "eb marks del removed the mark")
