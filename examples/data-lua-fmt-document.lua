-- EB tested example: Write a Lua data file
-- data-lua-fmt-document | snippet | topics: data, quests, instances
--
-- What it does:  ebkit.lua_fmt writes a table as a stable "return { ... }" file that load() reads back with no environment.
-- Tested:        The document starts with return, keeps the chosen key order, and loads back to the same values.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
