-- The after-looting guard: destroy only by exact name
--
-- An after-looting rule (destroy, transmute, salvage) acts on an item once it is in your bags. afterBlock(rule, item) says why it would be left alone: a destroy needs the item's exact name, and No-Trade, Heirloom, Lore or attuned items are never destroyed.
--
-- kind:      snippet
-- expect:    The exact-name destroy may go; the "contains" destroy and the No-Trade item are left alone with their reasons.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.lootrules
-- id:        econ-after-loot-guard

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
