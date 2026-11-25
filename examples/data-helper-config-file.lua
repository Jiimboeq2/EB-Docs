-- EB tested example: Keep a helper's own config in a JSON file
-- data-helper-config-file | snippet | topics: data, helpers
--
-- What it does:  Read your helper's file once at start, keep it in a table, and queue a save when it changes.
-- Tested:        The config loads with defaults for missing keys; a change is saved by the next flush, not in the frame.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
