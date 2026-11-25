-- A JSON null, and Lua values as text
--
-- ebkit.jsontable.null keeps a JSON null through a round trip; ebkit.lua_fmt.encode writes any value as a Lua literal, and ident says whether a key can be written bare.
--
-- kind:      snippet
-- expect:    The null survives encode and decode; a table becomes a Lua literal with bare and bracketed keys.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   ebkit.jsontable, ebkit.lua_fmt
-- id:        data-null-and-lua-values

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
