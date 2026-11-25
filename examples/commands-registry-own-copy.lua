-- A registry of your own, and wrapping a handler
--
-- Load EB's command list into a registry of your own (a tool or a test), answer a command, then wrap its handler to add a step - and take the wrapper off again.
--
-- kind:      snippet
-- expect:    The copy loads every shipped command; the wrapper runs before the original; detach leaves the command unanswered again.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.registry
-- id:        commands-registry-own-copy

-- your script
local R = require("eb.registry")
local reg = R.new()
local doc = assert(R.readFile("data/eb/commands.json"))    -- the shipped list (in game: under the EB folder)
assert(reg:load(doc))
reg:attach("util.timer", function(args) return true, "resting 30" end, { owner = "my.helper" })

local original = reg:handler("util.timer")
reg:attach("util.timer", function(args, ctx, parsed)
    local ok, text = original(args, ctx, parsed)
    return ok, "[checked] " .. tostring(text)
end, { owner = "my.helper", replace = true })              -- replace = true: take it over on purpose
local _, wrapped = reg:dispatch("eb timer add rest 30")
reg:detach("util.timer")
local okAfter, after = reg:dispatch("eb timer list")
print(("wrapped: %s | after detach: %s"):format(wrapped, after:match("does not answer on this box yet")))

-- check
DOCS.check(#reg:view({}) > 100, "the copy holds every shipped command")
DOCS.eq(wrapped, "[checked] resting 30", "the wrapper ran the original handler")
DOCS.eq(okAfter, false, "detached: the command is no longer answered")
local second, why = reg:attach("util.timer", function() return true end, { owner = "my.helper" })
local third, why2 = reg:attach("util.timer", function() return true end, { owner = "another.helper" })
DOCS.check(second and not third, "one owner per command")
DOCS.has(why2, "already wired", "a second owner is told who has it")
