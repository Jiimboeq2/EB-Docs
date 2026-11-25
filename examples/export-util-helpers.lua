-- EB tested example: Ability names, line keys and stable files
-- export-util-helpers | snippet | topics: data
--
-- What it does:  eb.exports.util holds the naming rule EB uses everywhere for "the same ability line" - the name without its
--                rank, lower case - and a serializer that writes the same table to the same text every time, so a saved export
--                diffs cleanly and reads back in an empty sandbox. b64encode makes any text one clean word for a transport.
-- Tested:        Every rank of the heal shares one line key; a table round-trips through serialize and deserialize; base64
--                round-trips.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local util = require("eb.exports.util")

-- your script
local name = "Fixture Mend IV"
print(("%s -> line '%s', rank %d"):format(name, util.lineKey(name), util.levelOf(name)))
local saved = util.serialize({ b = 2, a = { 1, 2, 3 }, note = "kept" })
local back = assert(util.deserialize(saved))
local word = util.b64encode("a line, with commas")

-- check
DOCS.eq(util.lineKey("Fixture Mend"), util.lineKey(name), "every rank shares the line key")
DOCS.eq(util.baseName(name), "Fixture Mend", "the name without its rank")
DOCS.eq(util.romanValue("XII"), 12, "a Roman numeral")
DOCS.eq(util.romanValue("Mend"), nil, "a word that is not one")
DOCS.eq(saved, util.serialize({ note = "kept", a = { 1, 2, 3 }, b = 2 }), "the same table writes the same text")
DOCS.eq(back.a[3], 3, "and reads back")
DOCS.eq(util.deserialize("os.exit()"), nil, "text that is not a table does not run as a script")
DOCS.check(not word:find(","), "base64 is one clean word")
DOCS.eq(util.b64decode(word), "a line, with commas", "and reads back")
