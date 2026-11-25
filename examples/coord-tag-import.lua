-- EB tested example: Read a cast stack's tags as rules
-- coord-tag-import | snippet | topics: combat, crew, data
--
-- What it does:  An imported cast stack's ability tag and embargo tag become plain rules; imported into an engine, the tag fires
--                and the hold works.
-- Tested:        Two rows with tags give three rules; casting the trigger ability fires the tag, which casts the listener; the
--                embargo trigger holds the bound ability.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script
local Import = require("eb.coord.tagimport")
local Coord = require("eb.coord.rules")
local rows = {
    { name = "Fixture Shout", ATag = "Burn", AType = "Trigger Only" },
    { name = "Fixture Strike", ATag = "Burn", AType = "Listen Only", Target = "@Group" },
    { name = "Fixture Blast", ETag = "Calm", EType = "Listen Only" },
    { name = "Fixture Jab" },                                              -- no tags: not coordination
}
local res = Import.importRows(rows)
local names = {}
for _, r in ipairs(res.rules) do names[#names + 1] = r.name end
print(("%d rules: %s"):format(#res.rules, table.concat(names, " | ")))

local now = 0
local coord = Coord.new({ me = { box = "is1", name = "Fixturae", role = "" }, clock = function() return now end })
local cast = {}
coord:onIntent(function(it) cast[#cast + 1] = it.ability end)
Import.importInto(coord, rows)
coord:feed({ kind = "cast", actor = "Fixturae", name = "Fixturae", ability = "Fixture Shout", isMe = true })
coord:add({ id = "calm-on", trigger = { kind = "chat", match = "calms" }, action = { kind = "embargo", tag = "Calm" } })
coord:feed({ kind = "chat", text = "The room calms" })

-- check
DOCS.eq(#res.rules, 3, "three rules from the tagged rows")
DOCS.eq(res.count.atag, 2, "two rows carried an ability tag")
DOCS.eq(cast[1], "Fixture Strike", "the tag made the listener cast")
DOCS.eq(coord:holdsCast("Fixture Blast"), true, "the embargo holds the bound ability")
