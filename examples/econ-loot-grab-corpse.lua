-- Loot a corpse by rule
--
-- The brain's lootGrab() opens the nearest corpse or chest, applies the rule to every drop, closes the window and answers "done", or "empty" when there is nothing to loot. lootPending() says whether there is something to loot. Each drop taken is a ledger line.
--
-- kind:      snippet
-- expect:    The gem is taken, the rag is left, and the next call answers "empty".
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy, eb.economy.loot
-- id:        econ-loot-grab-corpse

-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({ corpse = { id = 77, name = "a fixture brute's corpse" },
    window = { mode = "ffa", items = { { id = 1, name = "Fixture Gem" }, { id = 2, name = "Fixture Rag" } } } })
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me, wallNow = function() return 1763000000 end,
    cfg = { loot = { rules = { ["fixture gem"] = "need", ["fixture rag"] = "leave" } } } })

-- your script
local brain = eco:contract()                  -- the same table EB's brain calls between goals
DOCS.check(brain.lootPending(), "a corpse in reach")
local status
for _ = 1, 20 do
    status = brain.lootGrab()
    if status ~= "working" then break end
end
for _, it in ipairs(W.bags) do print("took: " .. it.name) end

-- check
DOCS.eq(status, "done", "looted")
DOCS.eq(#W.bags, 1, "only the gem was taken")
DOCS.check(not brain.lootPending(), "nothing left in reach")
DOCS.eq(brain.lootGrab(), "empty", "the next call: nothing to loot")
DOCS.has(eco.ledger:status().text, "1 looted", "the take is in the ledger")
