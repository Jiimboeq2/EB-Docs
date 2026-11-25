-- EB tested example: Split a typed line into scope and command
-- crew-parse-scope | snippet | topics: crew, commands
--
-- What it does:  wire.parseScope reads the one leading scope word of a line: local, all, others or to <who>.
-- Tested:        Each line splits into its scope, who and the command left over; a bare line is local.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local wire = require("eb.relay.wire")
local scope, who, rest = wire.parseScope("to is2,is3 follow Tankard")
print(("%s | %s | %s"):format(scope, who, rest))
local s2, _, r2 = wire.parseScope("others pause")
local s3, _, r3 = wire.parseScope("pause")
local s4, w4, r4 = wire.parseScope("to")                  -- "to" with nobody after it is NOT a broadcast

-- check
DOCS.eq(scope, "to", "the scope")
DOCS.eq(who, "is2,is3", "who")
DOCS.eq(rest, "follow Tankard", "the command left over")
DOCS.eq(s2 .. ":" .. r2, "others:pause", "others")
DOCS.eq(s3 .. ":" .. r3, "local:pause", "no scope word means this box")
DOCS.eq(s4 .. ":" .. w4 .. ":" .. r4, "local::to", "a lone to stays local")
DOCS.check(wire.isScopeWord("ALL") and not wire.isScopeWord("pause"), "scope words, any case")
