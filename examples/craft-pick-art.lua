-- EB tested example: Pick the reaction art for this moment of a combine
-- craft-pick-art | snippet | topics: items
--
-- What it does:  craft:pickArt(state, arts) is the decision EB makes every tick of a combine: rescue durability first, then
--                quality, else push progress - and only with an art that is ready.
-- Tested:        Low durability picks the durability art, low quality the quality art, a healthy combine the progress art, and
--                nothing ready picks nothing.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline: the economy facade with no game behind it (pickArt reads nothing)
local eco = require("eb.economy").new({ drive = {} })

-- your script
local arts = {
    { name = "Fixture Focus", boosts = "progress", ready = true },
    { name = "Fixture Steady", boosts = "durability", ready = true },
    { name = "Fixture Finesse", boosts = "quality", ready = true },
}
local low = eco.craft:pickArt({ durability = 40, quality = 90 }, arts)
local plain = eco.craft:pickArt({ durability = 95, quality = 50 }, arts)
local healthy = eco.craft:pickArt({ durability = 95, quality = 95 }, arts)
print("durability 40 -> " .. tostring(low))
print("quality 50 -> " .. tostring(plain))
print("all fine -> " .. tostring(healthy))
for _, a in ipairs(arts) do a.ready = false end
local none = eco.craft:pickArt({ durability = 30 }, arts)

-- check
DOCS.eq(low, "Fixture Steady", "durability is rescued first")
DOCS.eq(plain, "Fixture Finesse", "then quality")
DOCS.eq(healthy, "Fixture Focus", "a healthy combine pushes progress")
DOCS.eq(none, nil, "no art ready, no art cast")
