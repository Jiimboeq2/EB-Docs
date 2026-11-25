-- EB tested example: Read a command line without running it
-- commands-parse-line | snippet | topics: commands
--
-- What it does:  eb.registry.parse splits a line into its scope, who, command and typed arguments, or says what is wrong.
-- Tested:        The line reads as scope to, two boxes, follow with who and dist; a bad number is refused with the reason.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
