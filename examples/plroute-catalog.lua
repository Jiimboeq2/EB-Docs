-- EB tested example: The power-level routes EB ships, and their short codes
-- plroute-catalog | snippet | topics: tasks, data
--
-- What it does:  eb.plroutes.catalog() loads the shipped routes (a template to copy plus examples); list() summarizes them,
--                resolve() finds one by id, name or its PL- short code. The template's zones and spots are blank on purpose: its
--                check says what to fill in before it can run.
-- Tested:        The catalog lists the template first; it resolves the same entry by id, by name and by short code; the template
--                is marked fill-me-in.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- the shipped routes live in data/eb/plroutes beside EB's lua folder; a script started elsewhere names the folder
require("eb.plroutes.catalog").DATA_DIR = "data/eb/plroutes"
local routes = require("eb.plroutes")
local cat = assert(routes.catalog())
local list = routes.list()
print("first route: " .. list[1].name)

local byId = routes.resolve(cat, "template")
local byName = routes.resolve(cat, "General plan")
local byCode = routes.resolve(cat, byId.code)
local missing, why = routes.resolve(cat, "no such route")

DOCS.check(#list >= 2, "the template and the examples")
DOCS.eq(list[1].ready, false, "the template needs filling in")
DOCS.check(byId.check ~= "", "its check says what is missing")
DOCS.eq(byName, byId, "by name")
DOCS.eq(byCode, byId, "by short code")
DOCS.check(require("eb.plroutes.share").isShortCode(byId.code), "codes look like PL-XXXXXXX")
DOCS.eq(missing, nil, "an unknown route")
DOCS.has(why, "no route", "is refused with the reason")
