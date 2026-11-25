-- EB tested example: Exactly one box cures
-- coord-arbiter-one-cure | snippet | topics: crew, combat, helpers
--
-- What it does:  Two healers want the same cure: each lays a bid, the claim window closes, the same winner is picked on both
--                boxes, the winner casts and reports it landed.
-- Tested:        is1 waits out the claim window; is2 has already heard the better bid and stands down; then is1 gets go.
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

-- your script: one arbiter per box, on a relay link
local Arb = require("eb.coord.arbiter")
local Link = require("eb.coord.relaylink")
local function box(id, rank)
    local link = Link.new({ box = id, transport = bus.box(id) })
    local arb = Arb.new({ box = id, role = rank, link = link, clock = function() return now end })
    link.join()
    return arb
end
local a, b = box("is1", 10), box("is2", 20)
local cure = { action = "cure", target = "1234", scope = "group" }    -- the member being cured

local first = { a:request(cure), b:request(cure) }       -- both bid; is2 hears is1's better bid at once
now = 200                                                 -- the 150 ms window has passed
local ra, rb = a:request(cure), b:request(cure)
print(("is1 %s, is2 %s"):format(ra, rb))
if ra == "go" then a:acted(cure) end                      -- the winner casts and says so
local whileActing = b:statusOf("cure", "1234")
a:done(cure, true)                                        -- the cure landed: everyone clears it

-- check
DOCS.eq(first[1], "wait", "is1 waits while the window is open")
DOCS.eq(first[2], "standdown", "is2 already knows a better box wants it")
DOCS.eq(ra, "go", "the lower rank wins")
DOCS.eq(rb, "standdown", "the other box stands down")
DOCS.eq(whileActing, "standdown", "while is1 casts, is2 keeps standing down")
DOCS.eq(a:statusOf("cure", "1234"), "idle", "done cleared the claim")
