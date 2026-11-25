-- Read the heroic opportunity wheel
--
-- HOState() reads the heroic opportunity window: whether it is up, the wheel's name, and which of its icons are still open to complete.
--
-- kind:      snippet
-- expect:    Reads the wheel's name and its two icons, one of them open.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-heroic-wheel

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.setWindow("ho", { visible = true, name = "Fixture Wrath",
    wheel = { { slot = 1, icon = 4, open = true }, { slot = 3, icon = 9 } } })

-- your script
local game = require("eb.platform").game()
local st = game.HOState()
if st.visible and st.wheel then
    local open = 0
    for _, s in ipairs(st.wheel) do if s.open then open = open + 1 end end
    print(("wheel %s: %d icons, %d open"):format(st.name, #st.wheel, open))
end

-- check
DOCS.eq(st.visible, true, "the window is up")
DOCS.eq(st.wheel[1].icon, 4, "the first icon")
w.setWindow("ho", nil)
game.BeginTick()
DOCS.eq(game.HOState().visible, false, "and it reads not visible once it closes")
