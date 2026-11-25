-- Keep a helper's own config in a JSON file
--
-- Read your helper's file once at start, keep it in a table, and queue a save when it changes.
--
-- kind:      snippet
-- expect:    The config loads with defaults for missing keys; a change is saved by the next flush, not in the frame.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.platform, ebkit.jsontable
-- id:        data-helper-config-file

-- offline stand-in: the platform's files service over a disk in a table, and the flush job EB's boot runs for you
local w = DOCS.world()
local disk = require("data.lib.memdisk").install({ ["helper/lowhp.json"] = '{"threshold":40}' })
local P = require("eb.platform")
P.pulse().every("files", 250, function() P.files().flush(1) end, { prio = 90 })

-- your script
local J = require("ebkit.jsontable")
local PATH = "helper/lowhp.json"
local DEFAULTS = { threshold = 50, announce = true }
local function load()
    local cfg = {}
    local text = P.files().read(PATH)                  -- once, at start: never on every frame
    local doc = text and J.decode(text) or {}
    for k, v in pairs(DEFAULTS) do cfg[k] = (doc[k] ~= nil) and doc[k] or v end
    return cfg
end
local function save(cfg) P.files().writeLater(PATH, assert(J.encode(cfg))) end

local cfg = load()
cfg.threshold = 35
save(cfg)
w.runFor(300)
print(("threshold %d, saved %s"):format(cfg.threshold, disk[PATH]))

-- check
DOCS.eq(load().threshold, 35, "the saved value reads back")
DOCS.eq(load().announce, true, "a key missing from the file takes its default")
DOCS.eq(disk[PATH], '{"announce":true,"threshold":35}', "the file on disk")
