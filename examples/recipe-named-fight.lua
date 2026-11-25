-- Recipe: script a named fight
--
-- A complete named-fight script: the boss's emote sends you to a safe spot and back, half health switches the burn rows on, a detriment on a member is cured on cue, and the boss's big cast is interrupted on cue.
--
-- kind:      snippet
-- expect:    The emote moves you out of the fire and back home with the burn held meanwhile; phase 2 turns the burn on; Member1's detriment is cured; Ashen Wail is stunned; the script ends when the boss dies.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.events, eb.nav, eb.app.combat, eb.caststack.jsonstack_live, game, eb.platform
-- id:        recipe-named-fight

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real) -----------------------
local w = DOCS.world({ me = { x = 0, y = 0, z = 0 } })
require("nav.lib.navworld").attach(w, { zone = "fixture_lair" })
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Strike", "Fixture Burn", "Fixture Stun", "Fixture Cure" })
FW.recastOnUse(w, 2)                                           -- the game shows each cast as taken: the ability goes on its reuse
local boss = FW.mob(w, { id = 300, name = "the Ashen Overseer", type = "NamedNPC", distance = 5 })
FW.target(w, 300)
local member = w.addMember({ name = "Member1", id = 11, class = "templar", healthPct = 90, powerPct = 80, inZone = true,
                             afflict = { noxious = 0 } })
w.addActor({ id = 11, name = "Member1", type = "PC", isNPC = false, distance = 4 })
w.events()                                                     -- EB's boot attaches the game's events and ticks them
local JS = require("eb.caststack.jsonstack")
local app = require("eb.app.combat").new({ game = w.game, clock = w.P.now })   -- EB builds this once per box ...
app.holder.rebind(JS.build({ castStack = {                     -- ... with the character's own cast stack
    { slot = 1, name = "Fixture Burn",   ability = "Fixture Burn",   type = "CA", disabled = false, cond = { Tag = "BURN" } },
    { slot = 2, name = "Fixture Strike", ability = "Fixture Strike", type = "CA", disabled = false, cond = {} },
} }, { class = "warden" }))                                    -- (the stun is not in the rotation: the script casts it on cue)
w.pulse.every("eb.combat", 0, function(t) app.pump(t) end)    -- ... and steps it 4 times a second
eb.app = { combat = app }                                      -- in game: eb.app.combat

-- your script: the fight ------------------------------------------------------------------------------------------
local P = require("eb.platform")
local game, pulse = P.game(), P.pulse()
local events, nav = require("eb.events"), require("eb.nav")
local combat = eb.app.combat                                   -- EB's own combat plane: never build a second engine

local FIGHT = { boss = "the Ashen Overseer", emote = "draws in the flames", stopCast = "Ashen Wail", stun = "Fixture Stun",
                cure = "Fixture Cure", home = { x = 0, y = 0, z = 0 }, safe = { x = -20, y = 0, z = 0 }, log = {} }
combat.holder.setTagEnabled("BURN", false)                     -- phase 1: hold the burn

local cues = {}                                                -- handlers only record; the fight task acts
events.on("IncomingText", function(ev)
    if ev.text:find(FIGHT.emote, 1, true) then cues[#cues + 1] = "flames" end
end)

pulse.spawn("fight: " .. FIGHT.boss, function()
    local phase = 1
    while true do
        local b = game.Target()
        if not b or b.isDead or (b.healthPct or 0) <= 0 then break end
        if phase == 1 and b.healthPct <= 50 then               -- phase 2 at half health: burn on
            phase = 2
            combat.holder.setTagEnabled("BURN", true)
            FIGHT.log[#FIGHT.log + 1] = "phase 2"
        end
        if cues[1] == "flames" then                            -- the emote: out of the fire, then back in
            table.remove(cues, 1)
            combat.holder.setTagEnabled("BURN", false)
            local s, h = FIGHT.safe, FIGHT.home
            if nav.goPoint(s.x, s.y, s.z) then
                eb.delay(3000)
                if nav.goPoint(h.x, h.y, h.z) then FIGHT.log[#FIGHT.log + 1] = "out and back" end
            end
            if phase == 2 then combat.holder.setTagEnabled("BURN", true) end
        end
        if game.TargetCasting() == FIGHT.stopCast and game.AbilityReady(FIGHT.stun) then   -- the big cast: stop it
            game.Cast(FIGHT.stun)
            FIGHT.log[#FIGHT.log + 1] = "stunned " .. FIGHT.stopCast
        end
        for _, m in ipairs(game.Group()) do                    -- the cure on cue: a noxious detriment on anyone
            if (m.noxious or 0) > 0 and game.AbilityReady(FIGHT.cure) then
                game.Cast(FIGHT.cure, { name = m.name })
                FIGHT.log[#FIGHT.log + 1] = "cured " .. m.name
            end
        end
        eb.delay(250)
    end
    FIGHT.over = true
end)

-- offline: the fight plays out ------------------------------------------------------------------------------------
local function casted(name) for _, c in ipairs(w.world.casts) do if c.ability == name then return true end end end
local function burnOn()
    for _, e in ipairs(combat.holder.entries()) do if e.ability == "Fixture Burn" then return not e.disabled end end
end
local burnAway, onFrame = nil, w.world.onFrame
w.world.onFrame = function(h) onFrame(h); if w.self.x <= -18 then burnAway = burnOn() end end   -- watch the safe spot
w.runFor(500)
w.host:emitText("The Ashen Overseer draws in the flames!", 0)
w.runUntil(function() return FIGHT.log[1] == "out and back" end, 30000)
boss.healthPct = 45
w.runUntil(function() return FIGHT.log[2] == "phase 2" end, 3000)
member.afflict.noxious = 1
w.runUntil(function() return casted(FIGHT.cure) end, 3000)
member.afflict.noxious = 0
boss.castId, boss.castName = 77, FIGHT.stopCast
w.runUntil(function() return casted(FIGHT.stun) end, 3000)
boss.castId = 0
boss.healthPct, boss.isDead = 0, true
w.runUntil(function() return FIGHT.over end, 3000)
print("fight over: " .. table.concat(FIGHT.log, " | "))

-- check -----------------------------------------------------------------------------------------------------------
DOCS.eq(FIGHT.log[1], "out and back", "the emote sent us to the safe spot and back")
DOCS.check(math.sqrt(w.self.x ^ 2 + w.self.z ^ 2) <= 3, "home again after it")
DOCS.eq(FIGHT.log[2], "phase 2", "half health started phase 2")
DOCS.eq(FIGHT.log[3], "cured Member1", "the detriment was cured on cue")
DOCS.eq(FIGHT.log[4], "stunned Ashen Wail", "the boss's cast was interrupted on cue")
DOCS.eq(burnAway, false, "the burn was held while we stood at the safe spot")
DOCS.eq(burnOn(), true, "and ends switched on (phase 2)")
DOCS.eq(FIGHT.over, true, "the script ended with the boss")
