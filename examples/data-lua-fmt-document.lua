-- Write a Lua data file
--
-- ebkit.lua_fmt writes a table as a stable "return { ... }" file that load() reads back with no environment.
--
-- kind:      snippet
-- expect:    The document starts with return, keeps the chosen key order, and loads back to the same values.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   ebkit.lua_fmt
-- id:        data-lua-fmt-document

-- your script
local LF = require("ebkit.lua_fmt")
local route = { name = "a test hall", steps = { { kind = "walk", at = { 12.5, 0, -40 } }, { kind = "camp", at = { 30, 0, -12 } } } }
local text = LF.document(route, { order = function(t) return { "name", "kind" } end })   -- these keys first
print(text:match("^return {"))
local back = assert(load(text, "route", "t", {}))()        -- a data file needs no globals at all

-- check
DOCS.has(text, 'name = "a test hall"', "a bare key where Lua allows one")
DOCS.has(text, "at = {12.5, 0, -40}", "a short number list stays on one line")
DOCS.eq(back.steps[2].kind, "camp", "it loads back")
DOCS.eq(LF.document(route, { order = function() return { "name", "kind" } end }), text, "the same table writes the same text")
DOCS.eq(LF.num(150.0), "150", "numbers are minimal: never 150.0")
