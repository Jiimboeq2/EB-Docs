-- EB tested example: Clear junk without a vendor trip
-- econ-junk-by-rule | snippet | topics: items
--
-- What it does:  The brain's junk() frees bag slots by rule: an item whose tier is in cfg.vendor.junkTiers is sold when a
--                merchant window is open, destroyed otherwise. With no junk rule it does nothing at all and says "done". An item
--                whose type or tier the game has not told is never junked.
-- Tested:        Without a rule nothing moves; with the Junk tier listed the two junk stacks are destroyed and the good item
--                stays.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local function bags()
    return { { name = "Fixture Rag", type = "Loot", tier = "Junk" }, { name = "Fixture Bone", type = "Loot", qty = 4, tier = "Junk" },
             { name = "Fixture Ore", type = "Resource", qty = 30, tier = "Treasured" } }
end

-- your script, part 1: no rule configured - fail-safe, nothing is touched
local W1 = Fake.world({ bags = bags() })
local eco1 = require("eb.economy").new({ drive = Fake.drive(W1), me = W1.me })
local first = eco1:contract().junk()
DOCS.eq(first, "done", "no junk rule: done at once")
DOCS.eq(#W1.log, 0, "and nothing was sent to the game")

-- part 2: the Junk tier is junk
local W2 = Fake.world({ bags = bags() })
local eco2 = require("eb.economy").new({ drive = Fake.drive(W2), me = W2.me,
    cfg = { vendor = { junkTiers = { Junk = true } } } })
local status
for _ = 1, 20 do
    status = eco2:contract().junk()
    if status ~= "working" then break end
end
print("junk destroyed: " .. #W2.log)

-- check
DOCS.eq(status, "done", "the junk pass finished")
DOCS.eq(#W2.bags, 1, "only the ore is left")
DOCS.eq(W2.bags[1].name, "Fixture Ore", "the good item stayed")
