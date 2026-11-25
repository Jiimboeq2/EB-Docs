-- EB tested example: When the winner never finishes
-- coord-arbiter-failover | snippet | topics: crew, combat
--
-- What it does:  The box that won a rez casts it but never reports it landed; after the failover time the next box takes the rez,
--                so a member is never left lying.
-- Tested:        is1 wins and acts, then goes silent; 2.5 s later the rez is open again, is2 bids anew and, once its bid's short
--                window has passed, its request answers go.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: an in-memory relay between two boxes
local bus = require("eb.relay.events").bus()
local now = 0

-- your script
local Arb = require("eb.coord.arbiter")
local Link = require("eb.coord.relaylink")
local function box(id, rank)
    local link = Link.new({ box = id, transport = bus.box(id) })
    local arb = Arb.new({ box = id, role = rank, link = link, clock = function() return now end })
    link.join()
    return arb
end
local a, b = box("is1", 10), box("is2", 20)
local rez = { action = "rez", target = "5678", scope = "group" }

a:request(rez); b:request(rez)
now = 200
local won = a:request(rez)
b:request(rez)
a:acted(rez)                                  -- is1 starts the rez ... and its box dies before it lands
now = 1000; b:poll()
local early = b:request(rez)
now = 3000; b:poll()                          -- past the 2.5 s with no word from is1: the rez is open again
b:request(rez)                                -- is2 bids anew (a new round: its bid has a short window of its own)
now = 3200
local late = b:request(rez)
print("is2 takes over: " .. late)

-- check
DOCS.eq(won, "go", "is1 won the rez")
DOCS.eq(early, "standdown", "inside the failover time is2 still stands down")
DOCS.eq(late, "go", "after it, is2 takes the rez")
