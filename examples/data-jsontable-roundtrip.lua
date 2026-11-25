-- Turn a table into JSON and back
--
-- ebkit.jsontable encodes any plain table (object keys sorted, so the same table is always the same text).
--
-- kind:      snippet
-- expect:    The table encodes with sorted keys, decodes back equal, and bad input answers nil and a reason.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   ebkit.jsontable
-- id:        data-jsontable-roundtrip

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
