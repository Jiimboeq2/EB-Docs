-- EB tested example: Change one field in a JSON file another program owns
-- data-json-lossless-edit | snippet | topics: data
--
-- What it does:  ebkit.json reads losslessly: change one value, write it back, and the rest stays exactly as it was spelled.
-- Tested:        Only the edited value changes; a number spelled 1.50 and a key the script never touched come back the same.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
