-- Split a typed line into scope and command
--
-- wire.parseScope reads the one leading scope word of a line: local, all, others or to <who>.
--
-- kind:      snippet
-- expect:    Each line splits into its scope, who and the command left over; a bare line is local.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.relay.wire
-- id:        crew-parse-scope

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
