-- EB tested example: Write an empty list as []
-- data-jsontable-empty-list | snippet | topics: data, ui
--
-- What it does:  An empty Lua table encodes as {}; give an empty LIST the __tojson marker and it writes [] instead.
-- Tested:        A plain empty table writes {}; one with the __tojson marker writes [], inside a bigger state too.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
