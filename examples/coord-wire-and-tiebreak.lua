-- EB tested example: The coordination messages and the tie-break
-- coord-wire-and-tiebreak | snippet | topics: crew, data
--
-- What it does:  A tag and a claim as relay fields and back, the one claim key, and the tie-break every box computes the same
--                way.
-- Tested:        Both messages survive the round trip; the lower rank wins, a tie goes to the smaller box id.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
