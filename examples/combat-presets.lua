-- Presets per context
--
-- Set the combat preset for what you are doing: "instance" (everything on), "openworld" (no mez), "afk" (no AE, no mez, no heroic opportunities).
--
-- kind:      snippet
-- expect:    afk switches AE, mez and heroic opportunities off; instance switches them all back on.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.app.combat
-- id:        combat-presets

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
