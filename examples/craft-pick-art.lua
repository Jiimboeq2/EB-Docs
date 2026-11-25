-- Pick the reaction art for this moment of a combine
--
-- craft:pickArt(state, arts) is the decision EB makes every tick of a combine: rescue durability first, then quality, else push progress - and only with an art that is ready.
--
-- kind:      snippet
-- expect:    Low durability picks the durability art, low quality the quality art, a healthy combine the progress art, and nothing ready picks nothing.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.craft, eb.economy
-- id:        craft-pick-art

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
