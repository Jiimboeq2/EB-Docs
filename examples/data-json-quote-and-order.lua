-- One JSON string, and the key order files use
--
-- ebkit.json.quote writes one string exactly as the codec does; ebkit.json.less is the key order every EB file is written in, so a file reads the same on every computer.
--
-- kind:      snippet
-- expect:    Quotes, backslashes and newlines are escaped; keys sort by their bytes (capitals first).
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   ebkit.json
-- id:        data-json-quote-and-order

-- your script
local J = require("ebkit.json")
local q = J.quote('say "hi"\n')
local keys = { "b", "a", "B" }
table.sort(keys, J.less)
print(("%s | %s"):format(q, table.concat(keys, " ")))

-- check
DOCS.eq(q, '"say \\"hi\\"\\n"', "the escaped string")
DOCS.eq(keys[1], "B", "a capital sorts first")
DOCS.check(not J.less("a", "a"), "a key is not before itself")
