-- EB tested example: Remember what a bell's map offers
-- nav-bell-maps | snippet | topics: nav, helpers
--
-- What it does:  A bell's travel map may offer less than the network on file, and a city bell offers its reader's own side only.
--                Keep each ring in a bell map memory per side, ask it before ringing, and judge an open map read by read.
-- Tested:        For a good character the port's bell offers the steppe and lacks the isle; a character of no known side gets no
--                verdict; the open map is a miss for the isle and offers the steppe.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game EB keeps this memory in its own file)
local w = DOCS.world()

-- your script
local bellmaps = require("eb.nav_bellmaps")
local s = bellmaps.new()
bellmaps.recordSide(s, "Fixture Server", "Fixturae", "good", 1000)    -- the side her guild hall globe showed her
bellmaps.record(s, { server = "Fixture Server", zone = "fixture_port", bell = "bell", bind = "side:good",
    labels = { "Fixture Hollow", "Fixture Steppe" }, complete = true, asked = "Fixture Isle", now = 1000 })
local ctx = { server = "Fixture Server", zone = "fixture_port", me = "Fixturae", now = 5000 }
local steppe = bellmaps.verdict(ctx, "Fixture Steppe", s)
local isle = bellmaps.verdict(ctx, "Fixture Isle", s)
local stranger = bellmaps.verdict({ server = "Fixture Server", zone = "fixture_port", me = "Fixturo", now = 5000 },
    "Fixture Isle", s)
print("isle from the port's bell: " .. isle)

-- an open map, read twice (two reads that agree make a whole map)
local m = bellmaps.look(0)
bellmaps.mapShown(m, 100)
bellmaps.addRead(m, { "Fixture Hollow", "Fixture Steppe" }, 900)
bellmaps.addRead(m, { "Fixture Hollow", "Fixture Steppe" }, 1700)

-- check
DOCS.eq(steppe, "offers", "the bell offers the steppe")
DOCS.eq(isle, "lacks", "a whole map without the isle lacks it")
DOCS.eq(stranger, "unknown", "a character of no known side gets no verdict: ring and read")
DOCS.eq(bellmaps.judge(m, "Fixture Steppe", 4000), "offered", "the open map offers the steppe")
DOCS.eq(bellmaps.judge(m, "Fixture Isle", 4000), "miss", "and is a miss for the isle")
