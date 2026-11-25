-- EB tested example: Level the Transmuting skill on a stone merchant
-- transmute-level-skill | snippet | topics: items
--
-- What it does:  eco.transmute:levelTransmute(opts) opens the stone merchant, picks the cheapest stone in the currency most
--                stones cost, buys one (answering the purchase question only when it names that stone), transmutes it, and goes
--                again until the skill caps, the bags fill or the currency runs out.
-- Tested:        One round buys the stone, confirms the purchase for that exact stone, transmutes it and raises the skill from 30
--                to 31.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
