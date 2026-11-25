-- Check a buff without flooding the server
--
-- An effect's name lives in its effect info, which the game asks the SERVER for. HasEffect(name) resolves each effect's name once and keeps it, so asking every frame costs no more server requests.
--
-- kind:      snippet
-- expect:    The first check resolves the names (a few server requests); twenty more frames of checks add none.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-has-effect-cache

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.world.effects = {
    { id = 9001, name = "Fixture Ward", type = "Beneficial", icon = 11 },
    { id = 9002, name = "Fixture Haste", type = "Beneficial", icon = 12 },
}
w.world.stats.examine = 0                       -- the fake world counts every server request (an "examine" read)

-- your script
local game = require("eb.platform").game()
local up = game.HasEffect("Fixture Ward")
local first = w.world.stats.examine
for _ = 1, 20 do
    game.BeginTick()                            -- a new frame (EB's pulse does this every frame)
    game.HasEffect("Fixture Ward")
end
if up then
    print(("Fixture Ward is up; server requests: first frame %d, after 20 more frames %d"):format(first,
        w.world.stats.examine))
end

-- check
DOCS.eq(up, true, "the buff is found by name")
DOCS.eq(w.world.stats.examine, first, "no new server request once the names are known")
DOCS.check(first <= 3, "at most a few requests to learn the names")
