-- Open and advance a heroic opportunity
--
-- With no wheel up the engine opens a heroic opportunity with the stack's opener; with your wheel up it casts the art whose icon the wheel needs, holds rotation arts that would disturb it, and never uses an excluded ability.
--
-- kind:      snippet
-- expect:    The opener goes first, then Fixture Smash (icon 9) advances the wheel; Fixture Strike (icon 7) is held while the wheel runs; an excluded ability is never picked; switched off, nothing heroic is cast.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.combat.ho, eb.combat
-- id:        combat-ho-wheel

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Chance", "Fixture Smash", "Fixture Strike" })
FW.recastOnUse(w, 10)                         -- the game shows each cast as taken: the ability goes on its reuse
FW.mob(w, { id = 200, name = "a fixture brute" })
FW.target(w, 200)
local game = require("eb.platform").game()
local shim = game.combatShim()
local wheel = { visible = false }
shim.hoState = function() return wheel end    -- offline: the wheel read (EB for InnerSpace does not provide it yet)

-- your script
local stack = require("eb.caststack.jsonstack").holder({ entries = {
    { name = "Fixture Chance", ability = "Fixture Chance", group = "dps", tags = "HO_STARTER", priority = 10, gates = {} },
    { name = "Fixture Smash",  ability = "Fixture Smash",  group = "dps", tags = "CA", priority = 95, gates = {}, hoIcon = 9 },
    { name = "Fixture Strike", ability = "Fixture Strike", group = "dps", tags = "CA", priority = 90, gates = {}, hoIcon = 7 },
} })
local engine = require("eb.combat").new({ shim = shim, stacks = stack })

local d1 = engine:step()                                  -- no wheel: open one
wheel = { visible = true, started = true, mine = true, needIcon = 9 }    -- offline: your wheel is up and needs icon 9
w.runFor(500)                                         -- a quick art goes out at most every half second
local d2 = engine:step()                                  -- advance it with the matching art
print("heroic: " .. d1.reason .. ", " .. d2.reason)

local strikeHeld = engine:hoDisturbs(stack.get("Fixture Strike"))   -- icon 7 would disturb the running wheel
local smashOk = engine:hoDisturbs(stack.get("Fixture Smash"))       -- the needed icon may pass
engine:setHOExcludes({ "Fixture Smash" })
local excluded = engine:hoExcluded("fixture smash")
local advancer = engine:hoAdvancer(engine:snapshot(), 9)            -- the only icon-9 art is excluded now
local opener = engine:hoStarterEntry()
engine:toggle("ho", false)
w.runFor(500)
local d3 = engine:step()

-- check
DOCS.eq(d1.kind, "ho", "a heroic decision")
DOCS.eq(d1.ability, "Fixture Chance", "the opener first")
DOCS.eq(d2.ability, "Fixture Smash", "the art with the needed icon advances it")
DOCS.eq(strikeHeld, true, "a rotation art with another icon is held while the wheel runs")
DOCS.eq(smashOk, false, "the needed icon is not held")
DOCS.eq(excluded, true, "an excluded ability")
DOCS.eq(advancer, nil, "is never used to advance a wheel")
DOCS.eq(opener.ability, "Fixture Chance", "the stack's opener")
DOCS.eq(engine:entryHOIcon(stack.get("Fixture Strike")), 7, "an entry's icon")
DOCS.check(d3.kind ~= "ho", "switched off: nothing heroic")
