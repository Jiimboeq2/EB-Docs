-- EB tested example: A line heard twice runs once
-- crew-dedupe | snippet | topics: crew
--
-- What it does:  Every crew line carries a message id; a box acts on an id once, however many times the line arrives.
-- Tested:        The same message id is new the first time and a duplicate after; a different id is new again.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local wire = require("eb.relay.wire")
local seen = wire.seenSet(64)              -- a bounded set: it forgets the oldest ids past 64
local first = seen.add("is1#41")
local again = seen.add("is1#41")
local next = seen.add("is1#42")
print(("first %s, again %s, next %s"):format(tostring(first), tostring(again), tostring(next)))

-- a whole command line on the wire: encode, decode, and the id it carries
local fields = wire.encodeCmd({ from = "is1", seq = 43, scope = "to", who = "is2", line = "eb follow is1" })
local env = wire.decodeCmd(fields)

-- check
DOCS.eq(first, true, "a new id")
DOCS.eq(again, false, "the same id again is dropped")
DOCS.eq(next, true, "the next id is new")
DOCS.eq(env.mid, "is1#43", "the id is <box>#<sequence>")
DOCS.eq(env.line, "eb follow is1", "the line survives the trip, spaces and all")
DOCS.eq(seen.count(), 2, "two ids remembered")
