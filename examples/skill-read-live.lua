-- EB tested example: Read a crafting skill through the game layer
-- skill-read-live | snippet | topics: items, game
--
-- What it does:  The skill reader takes any object with Skill / SkillText / SkillAbsent / TSLevel - the game layer is one. A
--                skill EB cannot read yet answers ok = false with the reason: unknown, never a made-up 0.
-- Tested:        Tinkering reads 354 of 400 with the cap the levels give; a skill that does not read answers unknown.
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
