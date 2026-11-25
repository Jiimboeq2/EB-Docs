-- EB tested example: A registry of your own, and wrapping a handler
-- commands-registry-own-copy | snippet | topics: commands, helpers
--
-- What it does:  Load EB's command list into a registry of your own (a tool or a test), answer a command, then wrap its handler
--                to add a step - and take the wrapper off again.
-- Tested:        The copy loads every shipped command; the wrapper runs before the original; detach leaves the command unanswered
--                again.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
