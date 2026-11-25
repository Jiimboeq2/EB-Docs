-- EB tested example: Check EB's nav extension before you route
-- tlo-ebnav-probe | snippet | topics: tlos, nav
--
-- What it does:  EB's mesh router answers through its own EBNav TLO. Scripts never read EBNav directly: eb.navd checks that the
--                extension is loaded first (an unknown TLO prints an error in game) and says plainly why it cannot route.
-- Tested:        With the nav extension not loaded, eb.navd reports that and nothing reads the EBNav TLO.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()                              -- the offline world has no nav extension loaded

-- your script
local navd = require("eb.navd")
local ok, why = navd.lib()
if not ok then print("nav: not available (" .. tostring(why) .. ")") end

-- check
DOCS.eq(ok, nil, "no route without the extension")
DOCS.has(why, "not loaded", "and it says why")
for _, s in ipairs(w.host.log.parse) do DOCS.check(not s:find("EBNav.", 1, true), "EBNav was never read") end
