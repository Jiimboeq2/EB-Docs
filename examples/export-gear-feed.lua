-- EB tested example: Share gear exports across the crew
-- export-gear-feed | snippet | topics: crew, items
--
-- What it does:  Each box's gear feed builds its own export and publishes it on the crew relay; every box takes in its peers' and
--                holds the group table a loot or gear decision reads. Here two feeds are joined by a tiny in-memory transport
--                standing in for EB's relay, and a tick on each shares both exports.
-- Tested:        Each box ends up with both exports, a re-tick with nothing changed sends nothing, and the roster lists both.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local gearfeed = require("eb.exports.gearfeed")

-- a transport pair standing in for EB's relay (in game pass opts.relay = the crew relay)
local listeners = {}
local function transport()
    return { kind = "test",
        publish = function(cmd, payload)
            for _, fn in ipairs(listeners) do fn(payload) end
            return true
        end,
        subscribe = function(fn) listeners[#listeners + 1] = fn end }
end
local function host(name, sub)
    return { identity = function() return { name = name, class = "warrior", subClass = sub, level = 100 } end,
             worn = function() return { chest = { name = "a fixture breastplate", stats = { stamina = 90 } } } end,
             bags = function() return {} end }
end
local clock = 0
local now = function() return clock end

-- your script
local a = gearfeed.new({ transport = transport(), box = "is1", me = "Fixturae", now = now,
    gearOpts = { host = host("Fixturae", "guardian") } })
local b = gearfeed.new({ transport = transport(), box = "is2", me = "Tankard", now = now,
    gearOpts = { host = host("Tankard", "berserker") } })
a:tick(); b:tick()
local names = {}
for name in pairs(a:exports()) do names[#names + 1] = name end
table.sort(names)
print("is1 holds: " .. table.concat(names, ", "))
clock = clock + 1000
local again = a:tick()

-- check
DOCS.eq(#names, 2, "box 1 holds both exports")
DOCS.check(b:exports()["fixturae"] ~= nil, "box 2 holds box 1's, by name in any case")
DOCS.eq(again, "held", "nothing changed: nothing sent")
DOCS.eq(#a:boxes(), 2, "the roster lists both boxes")
DOCS.eq(a:peerCount(), 1, "one peer heard")
DOCS.check(a:decode(a:encode(a:build())) ~= nil, "a payload round-trips")
