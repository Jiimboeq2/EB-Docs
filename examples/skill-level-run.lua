-- Level Tinkering to its cap
--
-- eco.skilllevel:level("tinkering") reads the skill live before every round, crafts the band's rows, reads again, and stops when the skill caps - or blocks with the reason when a round gains nothing.
--
-- kind:      snippet
-- expect:    Tinkering goes from 18 to its cap of 20 in one round of the band's recipe and the run answers done.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.skilllevel, eb.economy
-- id:        skill-level-run

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
