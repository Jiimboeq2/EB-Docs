-- EB tested example: Writs and collections as chore loops
-- loop-errands-collections | snippet | topics: tasks, items
--
-- What it does:  The errand loop runs tradeskill writs through the economy's writs pillar (walking to the station first when one
--                is configured); the collections loop scribes every piece it already has, from the bags and the depot. Both are
--                brain goals: each tick does one bite, and they end "done".
-- Tested:        The writ run polls until the pillar says done; the collections pass scribes the pieces once and ends.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local Loops = require("eb.loops")

-- a brain to drive goals by hand (in game EB's brain calls goal:advance once per tick)
local b = { sub = { nav = { travelTo = function() return "arrived" end, walkTo = function() return "arrived" end } },
            logs = {}, cfg = {} }
function b:log(fmt, ...) self.logs[#self.logs + 1] = select("#", ...) > 0 and fmt:format(...) or fmt end
function b:markPointer() end
local snap = { zone = "Fixture Docks", x = 0, y = 0, z = 0 }
local function drive(goal)
    local st
    for _ = 1, 20 do st = goal:advance(b, snap); if st ~= "working" then break end end
    return st
end

-- the providers (offline: the economy's two pillars, as recorders)
local writCalls = 0
local writs = { run = function(self, opts) writCalls = writCalls + 1; return writCalls < 3 and "working" or "done" end }
local filled = {}
local collections = { fill = function(self, scope, opts) filled[#filled + 1] = scope; return "done", { added = 4 } end }

-- your script
local errands = Loops.new({ kind = "errands", params = { act = { writs = writs }, mode = "tradeskill", count = 2 } })
local e = drive(errands)
local col = Loops.new({ kind = "collections", params = { act = { collections = collections }, scope = "fixture" } })
local c = drive(col)
print(b.logs[1])

-- check
DOCS.eq(e, "done", "the writ run finished")
DOCS.eq(writCalls, 3, "polled until the pillar said done")
DOCS.eq(c, "done", "the collections pass finished")
DOCS.eq(filled[1], "fixture", "for the scope asked")
DOCS.has(table.concat(b.logs, "\n"), "scribed 4 piece(s)", "and said how many pieces it scribed")
