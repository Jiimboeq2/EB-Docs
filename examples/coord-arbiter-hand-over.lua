-- Hand a claim over at once
--
-- A box that cannot cast at all calls fail() and the next box takes the cure straight away; a box whose need went away calls release(); claims can also be carried over your own transport with onClaim.
--
-- kind:      snippet
-- expect:    After is1 fails, is2's next request is go; release clears the key; a claim fed by hand makes this box stand down.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.coord.arbiter, eb.coord.cowire
-- id:        coord-arbiter-hand-over

-- offline stand-in: an in-memory relay between two boxes
local bus = require("eb.relay.events").bus()
local now = 0

-- your script
local Arb = require("eb.coord.arbiter")
local Link = require("eb.coord.relaylink")
local W = require("eb.coord.cowire")
local function box(id, rank)
    local link = Link.new({ box = id, transport = bus.box(id) })
    local arb = Arb.new({ box = id, role = rank, link = link, clock = function() return now end })
    link.join()
    return arb
end
local a, b = box("is1", 10), box("is2", 20)
local cure = { action = "cure", target = "1234", scope = "group" }
a:request(cure); b:request(cure)
now = 200
a:request(cure)
a:fail(cure)                                    -- out of power: give the claim up now
local next = b:request(cure)
b:release(cure)                                 -- the member was cured by something else
local cleared = b:statusOf("cure", "1234")

-- a third arbiter with no link: carry a claim to it yourself (your own transport decoded it)
local c = Arb.new({ box = "is3", role = 30, clock = function() return now end })
c:onClaim(W.decodeClaim(W.encodeClaim({ from = "is9", seq = 1, role = 1, scope = "group", action = "rez",
    target = "77", phase = "bid" })))
local hand = c:request({ action = "rez", target = "77", scope = "group" })
print(("is1 failed -> is2 %s | released -> %s | hand-fed bid -> %s"):format(next, cleared, hand))

-- check
DOCS.eq(next, "go", "the next box takes over at once")
DOCS.eq(cleared, "idle", "release cleared this box's claim")
DOCS.eq(hand, "standdown", "a better bid carried by hand makes this box stand down")
