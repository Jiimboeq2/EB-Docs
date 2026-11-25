-- Answer an eb command with your own handler
--
-- Attach a handler to a command the schema declares, then run lines through the registry like typed ones.
--
-- kind:      snippet
-- expect:    The handler gets the parsed state argument; a second owner is refused unless it asks to replace.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.registry
-- id:        commands-attach-handler

-- your script
local R = require("eb.registry")
local reg = assert(R.default({ root = ".", fresh = true }))      -- data/eb/commands.json, the customer schema

local seen = {}
local ok, why = reg:attach("core.afk", function(args, ctx, parsed)
    seen[#seen + 1] = args.state                                  -- the schema's [state:onoff] argument, canonical
    return true, "afk " .. tostring(args.state) .. ": handled by my_helper"
end, { owner = "my_helper" })

local done, text = reg:dispatch("eb afk on")
print(text)
local _, text2 = reg:dispatch("afk yes")                          -- the "eb" head is optional; yes reads as on
local again, whyAgain = reg:attach("core.afk", function() return true end, { owner = "someone_else" })
local replaced = reg:attach("core.afk", function() return true, "new owner" end, { owner = "someone_else", replace = true })

-- check
DOCS.check(ok, "attached: " .. tostring(why))
DOCS.check(done, "the line ran")
DOCS.eq(seen[1], "on", "the parsed argument")
DOCS.eq(seen[2], "on", "yes is read as on")
DOCS.eq(again, false, "a second owner is refused")
DOCS.has(whyAgain, "already wired by my_helper", "and told who owns it")
DOCS.check(replaced, "replace = true takes it over on purpose")
DOCS.eq(select(2, reg:dispatch("eb afk off")), "new owner", "the new handler answers")
