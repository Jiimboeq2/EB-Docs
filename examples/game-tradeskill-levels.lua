-- EB tested example: Read your tradeskill level and a skill
-- game-tradeskill-levels | snippet | topics: game, items
--
-- What it does:  TSLevel() is your tradeskill level; Skill(id) answers a tradeskill skill's current and maximum from the Persona
--                window, or nil when it cannot be read - never a made-up 0.
-- Tested:        Reads the tradeskill level and the tinkering skill as 354 of 400.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
