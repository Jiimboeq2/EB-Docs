-- Change one field in a JSON file another program owns
--
-- ebkit.json reads losslessly: change one value, write it back, and the rest stays exactly as it was spelled.
--
-- kind:      snippet
-- expect:    Only the edited value changes; a number spelled 1.50 and a key the script never touched come back the same.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   ebkit.json
-- id:        data-json-lossless-edit

-- your script
local J = require("ebkit.json")
local file = '{\n  "scale": 1.50,\n  "theme": "bw",\n  "volume": 0.5\n}'
local doc = assert(J.read(file))
J.set(doc, "volume", J.num(0.8))                 -- numbers are kept as their text: J.num makes a new one
local out = J.write(doc)
print(out:match('"volume": [%d.]+'))

-- check
DOCS.has(out, '"scale": 1.50', "an untouched number keeps its spelling")
DOCS.has(out, '"theme": "bw"', "an untouched string too")
DOCS.eq(J.tonum(J.get(doc, "volume")), 0.8, "the edited value")
DOCS.eq(J.write(assert(J.read(file))), file, "read and written with no edit, the file comes back byte for byte")
DOCS.eq(table.concat(J.keys(doc), ","), "scale,theme,volume", "the keys in file order")
