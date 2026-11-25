-- Check EB's nav extension before you route
--
-- EB's mesh router answers through its own EBNav TLO. Scripts never read EBNav directly: eb.navd checks that the extension is loaded first (an unknown TLO prints an error in game) and says plainly why it cannot route.
--
-- kind:      snippet
-- expect:    With the nav extension not loaded, eb.navd reports that and nothing reads the EBNav TLO.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game, eb.navd
-- id:        tlo-ebnav-probe

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
