-- EB tested example: Level Tinkering to its cap
-- skill-level-run | snippet | topics: items
--
-- What it does:  eco.skilllevel:level("tinkering") reads the skill live before every round, crafts the band's rows, reads again,
--                and stops when the skill caps - or blocks with the reason when a round gains nothing.
-- Tested:        Tinkering goes from 18 to its cap of 20 in one round of the band's recipe and the run answers done.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in: a work bench, and a skill that rises by one for each item made (the game does that)
local CW = require("crafting.lib.craftworld")
local world = CW.world({ station = { name = "Work Bench" }, anyRecipe = true })
world.tinker = { cur = 18, max = 20 }
world.onMade = function(w) w.tinker.cur = math.min(w.tinker.cur + 1, w.tinker.max) end
local eco = CW.economy(world, { me = { level = 20 },
    shim = { Skill = function(id) if id == "tinkering" then return world.tinker.cur, world.tinker.max end end } })

-- your script: poll it until it answers
local status, why = CW.poll(function() return eco.skilllevel:level("tinkering") end, 2000)
print(("tinkering 18 -> %d: %s"):format(world.tinker.cur, status))

-- check
DOCS.eq(status, "done", "the run finished")
DOCS.eq(world.tinker.cur, 20, "at the cap")
DOCS.check(#world.made >= 2, "the band's recipe was crafted")
