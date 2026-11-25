-- The power-level routes EB ships, and their short codes
--
-- eb.plroutes.catalog() loads the shipped routes (a template to copy plus examples); list() summarizes them, resolve() finds one by id, name or its PL- short code. The template's zones and spots are blank on purpose: its check says what to fill in before it can run.
--
-- kind:      snippet
-- expect:    The catalog lists the template first; it resolves the same entry by id, by name and by short code; the template is marked fill-me-in.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.plroutes
-- id:        plroute-catalog

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
