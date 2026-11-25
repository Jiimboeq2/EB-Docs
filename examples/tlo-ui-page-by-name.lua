-- EB tested example: Read an interface element by its full name
-- tlo-ui-page-by-name | snippet | topics: tlos, ui
--
-- What it does:  EQ2UIPage[window,page].Child[type,full.element.name].GetProperty[prop] reads one element of the game's interface
--                by NAME. Always name the element; never walk a window's children by number.
-- Tested:        Reads the heroic window's visible flag by the element's full name; the game layer's HOState() agrees.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.setWindow("ho", { visible = true, name = "Fixture Wrath", wheel = { { slot = 1, icon = 4, open = true } } })

-- your script
local v = IS.Parse("${EQ2UIPage[_HUD,heroic].Child[page,_HUD.heroic].GetProperty[visible]}")
print("heroic window visible: " .. tostring(v))

-- check
DOCS.eq(v, "TRUE", "read by its full name")
DOCS.eq(require("eb.platform").game().HOState().visible, true, "the game layer reads it the same way")
