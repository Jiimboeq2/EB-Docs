-- EB tested example: Turn a table into JSON and back
-- data-jsontable-roundtrip | snippet | topics: data
--
-- What it does:  ebkit.jsontable encodes any plain table (object keys sorted, so the same table is always the same text).
-- Tested:        The table encodes with sorted keys, decodes back equal, and bad input answers nil and a reason.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local J = require("ebkit.jsontable")
local text = J.encode({ name = "Tankard", hp = 64, pos = { 12.5, 0, -40 } })
print(text)
local back = J.decode(text)
local bad, why = J.decode('{"hp": 64,')

-- check
DOCS.eq(text, '{"hp":64,"name":"Tankard","pos":[12.5,0,-40]}', "sorted keys; 0 and -40 written as integers")
DOCS.eq(back.pos[1], 12.5, "decoded back")
DOCS.eq(back.name, "Tankard", "strings come back as strings")
DOCS.eq(bad, nil, "malformed JSON is refused")
DOCS.check(type(why) == "string" and #why > 0, "with a reason, never an error")
DOCS.eq(J.encode({ 1, 2, 3 }), "[1,2,3]", "a 1..n table is an array")
