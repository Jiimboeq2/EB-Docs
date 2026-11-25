-- Share gear exports across the crew
--
-- Each box's gear feed builds its own export and publishes it on the crew relay; every box takes in its peers' and holds the group table a loot or gear decision reads. Here two feeds are joined by a tiny in-memory transport standing in for EB's relay, and a tick on each shares both exports.
--
-- kind:      snippet
-- expect:    Each box ends up with both exports, a re-tick with nothing changed sends nothing, and the roster lists both.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.exports.gearfeed
-- id:        export-gear-feed

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
