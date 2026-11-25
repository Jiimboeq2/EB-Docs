-- Look a route up in the catalog
--
-- eb.plroutes.catalog.load builds the shipped route catalog; resolve finds an entry by id, name or short code, and list gives one row per route with whether it is ready to run and what it still needs.
--
-- kind:      snippet
-- expect:    The template resolves by its id, its list row says it needs filling in, and an unknown key says so.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.plroutes.catalog
-- id:        plroute-catalog-lookup

local C = require("eb.plroutes.catalog")
C.DATA_DIR = "data/eb/plroutes"                   -- a script started outside EB's own folder names it

-- your script
local cat = assert(C.load())
local entry = assert(C.resolve(cat, "template"))
local rows = C.list(cat)
print("template ready: " .. tostring(rows[1].ready))
local none, why = C.resolve(cat, "no such route")

-- check
DOCS.eq(entry.id, "template", "found by id")
DOCS.eq(rows[1].id, "template", "the template lists first")
DOCS.check(rows[1].note ~= "", "with what it still needs")
DOCS.eq(none, nil, "an unknown key")
DOCS.has(why, "no route", "says so")
