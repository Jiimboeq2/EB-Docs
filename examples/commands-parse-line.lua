-- Read a command line without running it
--
-- eb.registry.parse splits a line into its scope, who, command and typed arguments, or says what is wrong.
--
-- kind:      snippet
-- expect:    The line reads as scope to, two boxes, follow with who and dist; a bad number is refused with the reason.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.registry.parse, eb.registry
-- id:        commands-parse-line

-- your script
local reg = assert(require("eb.registry").default({ root = ".", fresh = true }))
local Parse = require("eb.registry.parse")
local p = assert(Parse.parse(reg, 'eb to is2,is3 follow Tankard 4'))
print(("%s %s: %s"):format(p.scope, table.concat(p.who, ","), Parse.canonical(p)))
local bad, why = Parse.parse(reg, "eb follow Tankard close")       -- dist is a float
local quoted = Parse.parse(reg, 'eb announce "pull in five"')     -- the last string argument takes the rest

-- check
DOCS.eq(p.id, "nav.follow", "the command id")
DOCS.eq(p.args.who, "Tankard", "the who argument")
DOCS.eq(p.args.dist, 4, "dist read as a number")
DOCS.eq(bad, nil, "a word where a number belongs is refused")
DOCS.has(why, "wants a number", "with the reason")
DOCS.eq(quoted.args.text, "pull in five", "a quoted argument stays one")
