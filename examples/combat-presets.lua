-- EB tested example: Presets per context
-- combat-presets | snippet | topics: combat
--
-- What it does:  Set the combat preset for what you are doing: "instance" (everything on), "openworld" (no mez), "afk" (no AE, no
--                mez, no heroic opportunities).
-- Tested:        afk switches AE, mez and heroic opportunities off; instance switches them all back on.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()

-- your script
local game = require("eb.platform").game()
local combat = require("eb.app.combat").new({ game = game, clock = require("eb.platform").now })
local brain, engine = combat.facade.brain, combat.engine

local function show(label)
    print(("%s: AE %s, mez %s, HO %s"):format(label, tostring(engine:tagEnabled("AE")),
        tostring(engine.modules.mez), tostring(engine.modules.ho)))
end
brain.setPreset("afk");       show("afk")
brain.setPreset("openworld"); show("openworld")
brain.setPreset("instance");  show("instance")

-- check
brain.setPreset("afk")
DOCS.eq(engine:tagEnabled("AE"), false, "afk: AE off")
DOCS.eq(engine.modules.mez, false, "afk: mez off")
brain.setPreset("instance")
DOCS.eq(engine:tagEnabled("AE"), true, "instance: AE back on")
DOCS.eq(engine.modules.mez and engine.modules.ho, true, "instance: mez and HO on")
DOCS.eq(combat.facade.preset, "instance", "the preset in force")
