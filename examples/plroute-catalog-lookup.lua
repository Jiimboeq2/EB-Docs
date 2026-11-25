-- EB tested example: Look a route up in the catalog
-- plroute-catalog-lookup | snippet | topics: tasks, data
--
-- What it does:  eb.plroutes.catalog.load builds the shipped route catalog; resolve finds an entry by id, name or short code, and
--                list gives one row per route with whether it is ready to run and what it still needs.
-- Tested:        The template resolves by its id, its list row says it needs filling in, and an unknown key says so.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
