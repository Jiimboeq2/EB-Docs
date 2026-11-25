-- EB tested example: Follow a crew member with eb follow
-- nav-follow-command | snippet | topics: nav, commands, crew
--
-- What it does:  eb follow <name> starts a follow over the mesh and answers "issued" at once; the follow re-plans as the other
--                moves, and a script on that box ends it with eb.nav.stop().
-- Tested:        The command answers at once; a few seconds later you stand near Tankard; nav.stop() ends the follow.
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
w.addActor({ id = 50, name = "Tankard", type = "PC", isNPC = false, x = 24, y = 0, z = 10 })
local reg = w.registry()
require("eb.nav_register").wire(reg, {})            -- EB's start does this once for every box

-- your script
local nav = require("eb.nav")
local ok, text = reg:dispatch("eb follow Tankard")  -- never blocks: the follow runs on the pulse
print("follow: " .. tostring(text))
w.runFor(6000)
local near = math.sqrt((w.self.x - 24) ^ 2 + (w.self.z - 10) ^ 2)
local wasWalking = nav.stop("the docs example is done")
w.runFor(300)

-- check
DOCS.eq(ok, true, "the command was accepted")
DOCS.has(text, "issued", "and answered at once")
DOCS.check(near <= 6, "you caught up with Tankard (" .. string.format("%.1f", near) .. " m)")
DOCS.eq(wasWalking ~= nil, true, "nav.stop() answered")
DOCS.eq(require("eb.move").held("forward"), false, "and no movement key is left held")
