-- EB tested example: Read the heroic opportunity wheel
-- game-heroic-wheel | snippet | topics: game, combat, fights
--
-- What it does:  HOState() reads the heroic opportunity window: whether it is up, the wheel's name, and which of its icons are
--                still open to complete.
-- Tested:        Reads the wheel's name and its two icons, one of them open.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
