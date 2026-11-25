-- EB tested example: Put icons on a window's rows
-- ui-icons-for-rows | snippet | topics: ui
--
-- What it does:  eb.ui.icons resolves an ability, item or class name to an icon a page draws (or nil, and the page keeps its
--                glyph); iconmap gives the sheet math. Static tables, no game reads.
-- Tested:        The ability resolves with its backdrop, the item and the class resolve, an unknown name is nil; EB's own tables
--                load thousands of ability icons.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- your script: in a window, make the resolver once and use it while you build the state
local Icons = require("eb.ui.icons.icons")
local map = require("eb.ui.icons.iconmap")
local icons = Icons.new({                         -- small tables of your own here; Icons.new({ require = require }) loads EB's
    ability = { icons = { ["fixture strike"] = 1153 }, backs = { ["fixture strike"] = 315 } },
    item = { icons = { ["fixture tonic"] = 40 } },
    class = { classes = { warden = "Warden" } },
})
local row = { name = "Fixture Strike" }
row.icon = icons:forAbility(row.name)
local sp = icons:sprite(row.icon, 18)
local tonic = icons:forItem("Fixture Tonic")
local cls = icons:forClass("warden")
print(("%s -> %s at %d,%d | tonic item %d | warden %s"):format(row.name, sp.file, sp.bgX, sp.bgY, tonic.id, cls.file))

-- check
DOCS.eq(row.icon.back, 315, "the ability's backdrop tile")
DOCS.eq(icons:forAbility("Nothing Like It"), nil, "an unknown name has no icon")
DOCS.eq(map.norm("  Fixture   STRIKE "), "fixture strike", "names are looked up by a plain key")
DOCS.eq(map.backTile(65535), -1, "an empty backdrop reads -1")
DOCS.eq(map.locate(1153, true).atlas, 33, "id 1153 sits on sheet 33")
local own = Icons.new({ require = require })      -- EB's own tables
DOCS.check(own:counts().abilities > 1000, "EB ships thousands of ability icons")
