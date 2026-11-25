-- EB tested example: Which collection pieces you still miss
-- collection-scope | snippet | topics: items, quests
--
-- What it does:  eco.collections:journal() reads the journal's collections; scope(rows, word) picks the incomplete ones a word
--                names (an exact category wins, else a name that contains the word; "all" = every incomplete one); missing(word)
--                answers the piece names still needed and the ones that cannot be acted on.
-- Tested:        "fixture isle" is a category (two collections), "feathers" matches a name, "all" gives the three incomplete
--                ones; the missing pieces are cleaned of their "(...)" tag and the placeholder rows are set aside.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: the journal's collections page
local CW = require("crafting.lib.craftworld")
local world = CW.world({ journal = {
    { name = "Fixture Shells", category = "Fixture Isle", level = 10, have = { "a pink shell" }, missing = { "a blue shell", "[12345]" } },
    { name = "Fixture Bones", category = "Fixture Isle", level = 12, missing = { "a fixture rib" } },
    { name = "Fixture Coins", category = "Fixture Mainland", level = 20, missing = {} },
    { name = "Fixture Feathers", category = "Fixture Mainland", level = 20, missing = { "a gray feather (Shiny)", "?" } } } })
local eco = CW.economy(world)

-- your script
local Collections = require("eb.economy.collections")
local rows = eco.collections:journal()
local isle, how = Collections.scope(rows, "fixture isle")
local feathers, how2 = Collections.scope(rows, "feathers")
local all = Collections.scope(rows, "all")
local names, unresolved = eco.collections:missing("all")
print("missing: " .. table.concat(names, ", "))
for _, u in ipairs(unresolved) do print(("set aside: %s (%s)"):format(u.name, u.why)) end

-- check
DOCS.eq(#isle .. " " .. how, "2 category", "a category")
DOCS.eq(#feathers .. " " .. how2, "1 collection", "a name")
DOCS.eq(#all, 3, "every incomplete collection (the complete one is never picked)")
DOCS.eq(#names, 3, "three pieces to find")
DOCS.eq(#unresolved, 2, "a placeholder and an unknown row are set aside")
DOCS.eq(Collections.clean("a gray feather (Shiny)"), "a gray feather", "clean drops the trailing tag")
DOCS.eq(Collections.usable("[12345]"), false, "a placeholder is not usable")
