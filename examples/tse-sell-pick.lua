-- EB tested example: Sell the T.S.E pick at the merchant instead
-- tse-sell-pick | snippet | topics: tasks, items
--
-- What it does:  tse:sell (the T.S.E of the economy EB builds for the box) resolves the pick from the bags by the T.S.E config (a
--                names list and/or a set of tiers), takes each pick item's adornments off and keeps them, opens the merchant in
--                reach, sells the pick item by item through the rules-gated item action, and closes the window. With no pick
--                configured it sells nothing. Items the game has not told the type of are never in a pick.
-- Tested:        The two picked items are sold after one adornment is reclaimed; an empty config refuses to sell anything.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local Model = require("eb.economy.ledgermodel")

-- offline stand-in for the game's side of the economy (every name invented)
local bags = {
    { id = 1, name = "a fixture bracer", type = "armor", qty = 1, value = 50 },
    { id = 2, name = "a fixture ring", type = "jewelry", qty = 1, value = 20 },
    { id = 3, name = "a keepsake fixture", type = "armor", qty = 1, value = 5 },
}
local adorns, sold, open = { [1] = { { slot = 1 } } }, {}, false     -- the bracer wears one adornment
local function nameOf(id) for _, b in ipairs(bags) do if b.id == id then return b.name end end end
local function game() return {
    ["bags.items"] = function() return bags end,
    ["adorn.on"] = function(id) return adorns[id] or {} end,
    ["adorn.remove"] = function(id) adorns[id] = nil; return "done" end,
    ["merchant.isOpen"] = function() return open end,
    ["merchant.near"] = function() return { name = "a Guild Commodities Exporter" } end,
    ["merchant.open"] = function() open = true; return "done" end,
    ["merchant.sell"] = function(id) sold[#sold + 1] = nameOf(id); return "done" end,
    ["merchant.close"] = function() open = false end,
} end

-- your script: EB builds the economy once per box; the T.S.E is eco.tse
local Economy = require("eb.economy")
local eco = Economy.new({ me = { name = "Sellbox" }, log = function() end, drive = game(),
    cfg = { tse = { names = { "a fixture bracer", "a fixture ring" }, unadorn = true } } })
local tse = eco.tse
local pick = tse:resolvePick({})
local status
for _ = 1, 8 do status = tse:sell({}); if status ~= "working" then break end end
print("sold: " .. table.concat(sold, ", "))
local none, why = Economy.new({ me = { name = "Sellbox" }, log = function() end, cfg = {},
    drive = { ["bags.items"] = function() return bags end } }).tse:sell({})
local kinds = {}
for _, row in ipairs(eco.ledger:rows()) do kinds[#kinds + 1] = Model.kinds[row.kind] end

-- check
DOCS.eq(#pick, 2, "the names list picks two items from the bags")
DOCS.eq(status, "done", "the sale finished")
DOCS.eq(#sold, 2, "both picked items were sold, the keepsake was not")
DOCS.eq(adorns[1], nil, "the bracer's adornment was reclaimed first")
DOCS.eq(kinds[1], "unadorn", "and recorded in the ledger")
DOCS.eq(open, false, "the merchant window was closed again")
DOCS.eq(none, "blocked", "no pick configured: nothing is sold")
DOCS.has(why, "no T.S.E pick", "and it says so")
