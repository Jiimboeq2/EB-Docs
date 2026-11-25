-- Read a crafting skill through the game layer
--
-- The skill reader takes any object with Skill / SkillText / SkillAbsent / TSLevel - the game layer is one. A skill EB cannot read yet answers ok = false with the reason: unknown, never a made-up 0.
--
-- kind:      snippet
-- expect:    Tinkering reads 354 of 400 with the cap the levels give; a skill that does not read answers unknown.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.skills, game
-- id:        skill-read-live

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.self.tsLevel = 90
w.world.skills = { tinkering = { 354, 400 } }

-- your script
local game = require("eb.platform").game()
local Skills = require("eb.economy.skills")
local reader = Skills.new({ shim = game, me = function() return { level = game.Me().level } end })
local t = reader:read("tinkering")
print(("tinkering %d/%d (cap %d)"):format(t.cur, t.max, t.cap))
local other = reader:read("transmuting")
print("transmuting: " .. (other.ok and "read" or ("unknown - " .. other.why)))

-- check
DOCS.eq(t.ok, true, "tinkering read")
DOCS.eq(t.cur, 354, "its value")
DOCS.eq(t.cap, 500, "5 x the higher of the adventure (100) and tradeskill (90) level")
DOCS.eq(other.ok, false, "a skill that does not read is unknown")
DOCS.eq(other.cur, nil, "never a made-up 0")
