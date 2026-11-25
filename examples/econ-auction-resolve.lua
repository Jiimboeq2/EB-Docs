-- EB tested example: Give a gear drop to the member who gains the most
-- econ-auction-resolve | snippet | topics: items, crew, loot
--
-- What it does:  The Resolve auction (opt-in: cfg.loot.resolveAuction = true): an equipment drop in a leader's loot window goes
--                to the member who gains the most Resolve over what they wear in that slot. Each member's bid comes from the
--                group's gear exports. auction.bid / auction.winner are the pure rule; eco.auction:award(item, roster) picks the
--                winner from the exports.
-- Tested:        The tank gains 40 Resolve, the healer 10: the breastplate goes to the tank. With the auction off, nobody.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game's windows (in game EB builds the drive and reads the group's exports)
local Fake = require("economy.lib.drivefake")
local W = Fake.world()
local exports = {   -- what each member's box publishes: worn gear, class and level
    Tankard = { class = "guardian", level = 100, worn = { chest = { name = "Old Vest", stats = { resolve = 10 } } } },
    Healwell = { class = "templar", level = 100, worn = { chest = { name = "Good Robe", stats = { resolve = 40 } } } },
}
local drop = { name = "Fixture Breastplate", slot = "chest", stats = { resolve = 50 } }

-- your script: the pure rule
local A = require("eb.economy.auction")
DOCS.eq((A.bid(drop, exports.Tankard)), 40, "the tank gains 40")
DOCS.eq((A.bid(drop, exports.Healwell)), 10, "the healer gains 10")
DOCS.check(A.qualifies(drop, {}), "equipment with Resolve goes to auction")

-- the live call the leader's loot window makes
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me,
    cfg = { loot = { resolveAuction = true, exports = exports } } })
local who = eco.auction:award(drop, { "Tankard", "Healwell" })
print(("%s -> %s (+%d)"):format(drop.name, who, A.bid(drop, exports[who])))

-- check
DOCS.eq(who, "Tankard", "the biggest gain wins")
local off = require("eb.economy").new({ drive = Fake.drive(W), me = W.me, cfg = { loot = { exports = exports } } })
local none, why = off.auction:award(drop, { "Tankard", "Healwell" })
DOCS.eq(none, nil, "the auction is off unless you turn it on")
DOCS.eq(why, "auction off", "and says so")
