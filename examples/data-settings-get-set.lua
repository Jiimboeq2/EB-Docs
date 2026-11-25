-- EB tested example: Read and change an EB setting
-- data-settings-get-set | snippet | topics: data, settings
--
-- What it does:  P.settings() is EB's settings store: get with a default, set for the session, save once off the hot path.
-- Tested:        get answers the default for an unset key; set changes it and marks the store dirty; save says why it cannot.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
