-- EB tested example: A JSON null, and Lua values as text
-- data-null-and-lua-values | snippet | topics: data
--
-- What it does:  ebkit.jsontable.null keeps a JSON null through a round trip; ebkit.lua_fmt.encode writes any value as a Lua
--                literal, and ident says whether a key can be written bare.
-- Tested:        The null survives encode and decode; a table becomes a Lua literal with bare and bracketed keys.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local J = require("ebkit.jsontable")
local F = require("ebkit.lua_fmt")
local text = J.encode({ gone = J.null })
local back = J.decode(text)
local lua = F.encode({ one = 1, ["two words"] = 2 })
print(("%s | %s"):format(text, (lua:gsub("%s+", " "))))

-- check
DOCS.eq(back.gone, J.null, "decode gives the same null back")
DOCS.check(F.ident("one"), "a plain name is written bare")
DOCS.check(not F.ident("two words"), "a key with a space needs brackets")
DOCS.has(lua, '["two words"] = 2', "the bracketed key")
DOCS.eq(load("return " .. lua)().one, 1, "the text loads back as the same table")
