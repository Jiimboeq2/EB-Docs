-- EB tested example: The after-looting guard: destroy only by exact name
-- econ-after-loot-guard | snippet | topics: items, helpers, loot
--
-- What it does:  An after-looting rule (destroy, transmute, salvage) acts on an item once it is in your bags. afterBlock(rule,
--                item) says why it would be left alone: a destroy needs the item's exact name, and No-Trade, Heirloom, Lore or
--                attuned items are never destroyed.
-- Tested:        The exact-name destroy may go; the "contains" destroy and the No-Trade item are left alone with their reasons.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local LR = require("eb.economy.lootrules")
local d = LR.parse({ rules = {
    { id = "a", match = "exact", item = "a fixture rag", act = "destroy" },
    { id = "b", match = "contains", item = "fixture scrap", act = "destroy" },
} })
local rag = { name = "a fixture rag", type = "Item", tier = "COMMON" }
local scrap = { name = "a fixture scrap", type = "Item", tier = "COMMON" }
local boundRag = { name = "a fixture rag", type = "Item", tier = "COMMON", noTrade = true }
local function verdict(it)
    local rule = LR.afterRule(d.rules, it.name)
    local why = rule and LR.afterBlock(rule, it, false, false) or "no rule"
    return why == "" and "go" or why
end
print(("exact: %s; contains: %s; no-trade: %s"):format(verdict(rag), verdict(scrap), verdict(boundRag)))

-- check
DOCS.eq(verdict(rag), "go", "an exact-name destroy may go")
DOCS.eq(LR.destroyOk(LR.afterRule(d.rules, "a fixture scrap")), false, "a contains text never destroys")
DOCS.eq(verdict(boundRag), "it is No-Trade", "No-Trade is never destroyed")
