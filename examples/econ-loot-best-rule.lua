-- EB tested example: Which loot rule names an item
-- econ-loot-best-rule | snippet | topics: items, data, loot
--
-- What it does:  lootrules.parse(doc) reads a loot-rules table; bestRule(rules, name, facts) picks the rule that decides an item.
--                The most specific rule wins: an exact name beats a "contains" text, a longer text a shorter one.
-- Tested:        The exact-name rule wins for the rune; the "contains" rule takes the other shards; an unnamed item has no rule.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script: the rules a box keeps in its own loot-rules file, decoded to a Lua table
local LR = require("eb.economy.lootrules")
local d = LR.parse({
    fallback = "leave",
    rules = {
        { id = "r1", match = "contains", item = "shard", act = "greed" },
        { id = "r2", match = "exact", item = "Fixture Rune Shard", act = "need" },
    },
})
local out = {}
for _, name in ipairs({ "Fixture Rune Shard", "a cracked fixture shard", "a fixture pelt" }) do
    local rule = LR.bestRule(d.rules, name, {})
    out[#out + 1] = name .. " -> " .. (rule and rule.act or "(no rule)")
end
print(table.concat(out, "; "))

-- check
DOCS.eq(LR.bestRule(d.rules, "fixture rune shard", {}).id, "r2", "names compare without case")
DOCS.eq(LR.bestRule(d.rules, "a cracked fixture shard", {}).act, "greed", "the contains rule")
DOCS.eq(LR.bestRule(d.rules, "a fixture pelt", {}), nil, "no rule names it")
DOCS.eq(d.opts.fallback, "leave", "what happens to an item no rule names")
