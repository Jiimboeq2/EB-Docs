-- EB tested example: Keep a null in a JSON document
-- data-jsontable-null | snippet | topics: data
--
-- What it does:  decode turns null into J.null (a key with no value stays a key); J.val(v) turns it back into nil.
-- Tested:        The null keeps its key, reads as nil through J.val, and encodes back as null.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local J = require("ebkit.jsontable")
local doc = J.decode('{"target":null,"zone":"a_test_hall"}')
print("target: " .. tostring(J.val(doc.target)))

-- check
DOCS.check(doc.target == J.null, "null decodes to the J.null marker, so the key is kept")
DOCS.eq(J.val(doc.target), nil, "J.val reads it as nil")
DOCS.eq(J.val(doc.zone), "a_test_hall", "and passes every other value through")
DOCS.eq(J.encode(doc), '{"target":null,"zone":"a_test_hall"}', "it encodes back as null")
