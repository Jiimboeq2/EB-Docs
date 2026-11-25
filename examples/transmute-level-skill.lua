-- Level the Transmuting skill on a stone merchant
--
-- eco.transmute:levelTransmute(opts) opens the stone merchant, picks the cheapest stone in the currency most stones cost, buys one (answering the purchase question only when it names that stone), transmutes it, and goes again until the skill caps, the bags fill or the currency runs out.
--
-- kind:      snippet
-- expect:    One round buys the stone, confirms the purchase for that exact stone, transmutes it and raises the skill from 30 to 31.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.transmute, eb.economy
-- id:        transmute-level-skill

-- offline stand-in: a stone merchant in reach, 50 marks, and a skill that rises with each transmute
local CW = require("crafting.lib.craftworld")
local world = CW.world({ merchant = { name = "a fixture stone merchant" }, currency = { ["fixture marks"] = 50 },
    offers = { { name = "Transmuter's Stone (Fixture)", price = { amount = 5, currency = "fixture marks" } } } })
world.tm = { cur = 30, max = 40 }
world.onTransmute = function(w) w.tm.cur = w.tm.cur + 1 end
local eco = CW.economy(world)

-- your script: opts.skill reads the skill (in game EB reads it from the game layer); oneRound stops after one
local status = CW.poll(function()
    return eco.transmute:levelTransmute({ oneRound = true, skill = function() return world.tm.cur, world.tm.max end })
end)
print(("one round: Transmuting %d/%d, %d marks left"):format(world.tm.cur, world.tm.max, world.currency["fixture marks"]))

-- check
DOCS.eq(status, "done", "the round finished")
DOCS.eq(world.tm.cur, 31, "one transmute, one skill point")
DOCS.eq(world.answers[1].choice, 1, "the purchase question was answered Yes")
DOCS.has(world.answers[1].prompt, "Transmuter's Stone (Fixture)", "because it named the stone being bought")
DOCS.eq(world.merchantOpen, false, "the merchant window was closed")
