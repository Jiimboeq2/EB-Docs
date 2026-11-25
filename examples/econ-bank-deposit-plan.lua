-- EB tested example: Plan a bank deposit before you make it
-- econ-bank-deposit-plan | snippet | topics: items
--
-- What it does:  eco.bank:deposit{ which, filter | items | bags | all, page, dry } puts bag items in the personal, shared or
--                guild bank. dry = true answers the plan without moving anything: what would go and what stays, with the reason
--                (a bag, a protected item, an account valuable, info not loaded). A guild deposit needs a page, 1 to 4.
-- Tested:        The dry run keeps the bag, the protected charm and the training writ; the real deposit moves the ore.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game's windows (in game EB builds the drive)
local Fake = require("economy.lib.drivefake")
local W = Fake.world({ bags = {
    { name = "Fixture Ore", qty = 30 }, { name = "Fixture Satchel", container = true },
    { name = "Fixture Charm" }, { name = "Lesser Mount Training Writ" },
} })
local eco = require("eb.economy").new({ drive = Fake.drive(W), me = W.me,
    cfg = { protect = { names = { ["fixture charm"] = true } } } })

-- your script: the plan first
local s, plan = eco.bank:deposit({ which = "shared", all = true, dry = true })
for _, k in ipairs(plan.kept) do print("kept: " .. k.item.name .. " (" .. k.why .. ")") end
DOCS.eq(s, "done", "a dry run answers at once")
DOCS.eq(#plan.picked, 1, "only the ore would go")
DOCS.eq(#plan.kept, 3, "the bag, the protected item and the valuable stay")

-- a guild deposit without a page is refused
local g, gwhy = eco.bank:deposit({ which = "guild", filter = { names = { "Fixture Ore" } } })
DOCS.eq(g, "blocked", "the guild bank needs a page")
DOCS.has(gwhy, "page", "the reason")

-- the real deposit: the ore, by name, into the shared bank
local status
for _ = 1, 20 do
    status = eco.bank:deposit({ which = "shared", filter = { names = { "Fixture Ore" } } })
    if status ~= "working" then break end
end

-- check
DOCS.eq(status, "done", "deposited")
DOCS.eq(W.bank.rows.shared[1].name, "Fixture Ore", "the ore is in the shared bank")
DOCS.eq(#W.bags, 3, "the rest stayed in the bags")
