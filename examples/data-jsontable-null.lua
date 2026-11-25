-- Keep a null in a JSON document
--
-- decode turns null into J.null (a key with no value stays a key); J.val(v) turns it back into nil.
--
-- kind:      snippet
-- expect:    The null keeps its key, reads as nil through J.val, and encodes back as null.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   ebkit.jsontable
-- id:        data-jsontable-null

-- your script
local J = require("ebkit.jsontable")
local doc = J.decode('{"target":null,"zone":"a_test_hall"}')
print("target: " .. tostring(J.val(doc.target)))

-- check
DOCS.check(doc.target == J.null, "null decodes to the J.null marker, so the key is kept")
DOCS.eq(J.val(doc.target), nil, "J.val reads it as nil")
DOCS.eq(J.val(doc.zone), "a_test_hall", "and passes every other value through")
DOCS.eq(J.encode(doc), '{"target":null,"zone":"a_test_hall"}', "it encodes back as null")
