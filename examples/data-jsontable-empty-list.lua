-- Write an empty list as []
--
-- An empty Lua table encodes as {}; give an empty LIST the __tojson marker and it writes [] instead.
--
-- kind:      snippet
-- expect:    A plain empty table writes {}; one with the __tojson marker writes [], inside a bigger state too.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   ebkit.jsontable
-- id:        data-jsontable-empty-list

-- your script
local J = require("ebkit.jsontable")
local EMPTY_LIST = { __tojson = function() return "[]" end }
local function emptyList() return setmetatable({}, EMPTY_LIST) end    -- the marker always writes []: empty lists only

local state = { name = "Tankard", buffs = emptyList() }
print(J.encode(state))

-- check
DOCS.eq(J.encode({}), "{}", "a plain empty table is an object")
DOCS.eq(J.encode(state), '{"buffs":[],"name":"Tankard"}', "the marked one is a list")
DOCS.eq(J.encode({ buffs = { "Shield", "Haste" } }), '{"buffs":["Shield","Haste"]}', "a list with items needs no marker")
