-- Read an interface element by its full name
--
-- EQ2UIPage[window,page].Child[type,full.element.name].GetProperty[prop] reads one element of the game's interface by NAME. Always name the element; never walk a window's children by number.
--
-- kind:      snippet
-- expect:    Reads the heroic window's visible flag by the element's full name; the game layer's HOState() agrees.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        tlo-ui-page-by-name

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.setWindow("ho", { visible = true, name = "Fixture Wrath", wheel = { { slot = 1, icon = 4, open = true } } })

-- your script
local v = IS.Parse("${EQ2UIPage[_HUD,heroic].Child[page,_HUD.heroic].GetProperty[visible]}")
print("heroic window visible: " .. tostring(v))

-- check
DOCS.eq(v, "TRUE", "read by its full name")
DOCS.eq(require("eb.platform").game().HOState().visible, true, "the game layer reads it the same way")
