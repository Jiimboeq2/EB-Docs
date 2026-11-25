-- Put icons on a window's rows
--
-- eb.ui.icons resolves an ability, item or class name to an icon a page draws (or nil, and the page keeps its glyph); iconmap gives the sheet math. Static tables, no game reads.
--
-- kind:      snippet
-- expect:    The ability resolves with its backdrop, the item and the class resolve, an unknown name is nil; EB's own tables load thousands of ability icons.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.ui.icons.icons, eb.ui.icons.iconmap
-- id:        ui-icons-for-rows

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
