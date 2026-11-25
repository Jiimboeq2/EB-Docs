-- EB tested example: Wait for the group at a mark
-- crew-group-barrier | snippet | topics: crew, instances
--
-- What it does:  group.barrier(name) is non-blocking: call it each tick until every member here has reached the same mark.
-- Tested:        The barrier waits while one member is missing, is ready once both marks are in, and times out on its own.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: the group as the world snapshot reports it, and a clock you step
local t = { now = 0 }
local world = { snapshot = function()
    return { name = "Tankard", class = "guardian", group = { count = 2, members = {
        { name = "Mendwell", zone = "a_test_hall", subclass = "templar" },
        { name = "Sparkwick", zone = "a_test_hall", subclass = "wizard" } } } }
end }
local peerMarks = {}

-- your script
local Group = require("eb.relay.group")
local G = Group.new({ world = world, me = { box = "is1", name = "Tankard", subclass = "guardian" },
    clock = function() return t.now end,
    broadcastMark = function(name) end,                       -- (offline: EB puts the mark on the crew relay)
    peerMarks = function() return peerMarks end })
local seen = {}
seen[#seen + 1] = G.barrier("door", { timeoutMs = 15000 })   -- nobody else has reached it yet
peerMarks.mendwell = "door"
seen[#seen + 1] = G.barrier("door", { timeoutMs = 15000 })   -- one of two
peerMarks.sparkwick = "door"
seen[#seen + 1] = G.barrier("door", { timeoutMs = 15000 })   -- everyone here
print("barrier: " .. table.concat(seen, ", "))

G.resetBarrier()                                              -- the next objective starts fresh
peerMarks = {}
G.barrier("boss", { timeoutMs = 5000 })
t.now = 6000
local late = G.barrier("boss", { timeoutMs = 5000 })

-- check
DOCS.eq(table.concat(seen, ","), "waiting,waiting,ready", "waits until every member has the mark")
DOCS.eq(late, "timeout", "never a silent hang: it times out and the caller decides")
