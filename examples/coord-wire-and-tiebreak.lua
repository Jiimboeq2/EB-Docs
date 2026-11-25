-- The coordination messages and the tie-break
--
-- A tag and a claim as relay fields and back, the one claim key, and the tie-break every box computes the same way.
--
-- kind:      snippet
-- expect:    Both messages survive the round trip; the lower rank wins, a tie goes to the smaller box id.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.coord.cowire
-- id:        coord-wire-and-tiebreak

-- your script
local W = require("eb.coord.cowire")
local tag = W.decodeTag(W.encodeTag({ from = "is1", seq = 7, scope = "group", phase = "raise", tag = "Hold Fire",
    data = "20000" }))
local claim = W.decodeClaim(W.encodeClaim({ from = "is2", seq = 3, role = 5, scope = "raid", action = "Cure",
    target = "1234", phase = "bid" }))

local bids = { { from = "is1", role = 10 }, { from = "is2", role = 5 }, { from = "is3", role = 10 } }
local best = W.winner(bids)
local tie = W.winner({ { from = "is3", role = 10 }, { from = "is1", role = 10 } })
local key = W.claimKey("Cure", "1234", "raid")
print(("winner %s (rank %d) | tie goes to %s | key %s"):format(best.from, best.role, tie.from, key))

-- check
DOCS.eq(tag.tag, "HoldFire", "a tag travels without spaces")
DOCS.eq(tag.phase, "raise", "an embargo raise")
DOCS.eq(tag.data, "20000", "the free-text field comes back whole")
DOCS.eq(tag.mid, "is1#7", "every message carries <box>#<seq>")
DOCS.eq(claim.role, 5, "the rank comes back as a number")
DOCS.eq(claim.action, "cure", "actions are lower case on the wire")
DOCS.check(W.outranks({ from = "is9", role = 1 }, { from = "is1", role = 2 }), "a lower rank beats a smaller box id")
