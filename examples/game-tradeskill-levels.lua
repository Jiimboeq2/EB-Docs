-- Read your tradeskill level and a skill
--
-- TSLevel() is your tradeskill level; Skill(id) answers a tradeskill skill's current and maximum from the Persona window, or nil when it cannot be read - never a made-up 0.
--
-- kind:      snippet
-- expect:    Reads the tradeskill level and the tinkering skill as 354 of 400.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-tradeskill-levels

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.self.tsLevel = 90
w.world.skills = { tinkering = { 354, 400 } }

-- your script
local game = require("eb.platform").game()
local cur, max = game.Skill("tinkering")
print(("tradeskill %d, tinkering %s"):format(game.TSLevel(), game.SkillText("tinkering") or "unknown"))

-- check
DOCS.eq(cur, 354, "the current skill")
DOCS.eq(max, 400, "the maximum")
DOCS.eq(game.Skill("no such skill"), nil, "an unknown skill is nil")
