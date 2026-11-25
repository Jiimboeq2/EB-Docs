-- Read and change an EB setting
--
-- P.settings() is EB's settings store: get with a default, set for the session, save once off the hot path.
--
-- kind:      snippet
-- expect:    get answers the default for an unset key; set changes it and marks the store dirty; save says why it cannot.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.platform
-- id:        data-settings-get-set

-- offline stand-in: no EB folder is known here, so the store cannot be saved (in game save() writes eb-settings.json)
local w = DOCS.world()
eb.root = ""

-- your script
local settings = require("eb.platform").settings()
local before = settings.get("ui.miniOnLogin", true)
settings.set("ui.miniOnLogin", false)
print("ui.miniOnLogin = " .. tostring(settings.get("ui.miniOnLogin", true)))
local saved, why = settings.save()                   -- once, from a task or on stop: never every frame

-- check
DOCS.eq(before, true, "an unset key answers the default")
DOCS.eq(settings.get("ui.miniOnLogin", true), false, "set changed it")
DOCS.eq(settings.dirty(), true, "the store knows it has unsaved changes")
DOCS.eq(saved, false, "offline there is nowhere to save")
DOCS.has(why, "no settings path", "and save() says why instead of raising")
