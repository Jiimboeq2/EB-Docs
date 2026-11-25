-- Read a fight's sensors through the world facade
--
-- Every condition in an encounter reads through runner:worldFacade(): fight timers, a curable detriment, a chat or emote line since the pull, an item in the bags, an actor's type. Here each sensor is wired to a small fake and read directly, the way a custom fn = function(ctx) action reads ctx.w.
--
-- kind:      snippet
-- expect:    The timer counts from its reset, the detriment, emote and item sensors answer what the fakes hold, and the actor's type comes from the combat interface's row.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.ic
-- id:        ic-world-facade-sensors

-- offline stand-in for the game: the combat and events interfaces the sensors read through
local ICW = require("instances.lib.icworld")
local env, world = ICW.make({ start = "copy", alive = { ["Overseer of Fixtures"] = 80 } })
env.combat.detriment = function(q) return q.type == "noxious" end                 -- a noxious curse is up
env.combat.hasItem = function(name) return name == "a fixture tonic" end
env.combat.find = function(name) return name == "Overseer of Fixtures" and { name = name, type = "NamedNPC" } or nil end
local heard = { { at = 0, text = "The Overseer of Fixtures roars: the floor will burn!" } }
env.events = { chatSeen = function(match, sinceMs)
    for _, l in ipairs(heard) do if l.at >= sinceMs and l.text:find(match, 1, true) then return true end end
    return false
end }

-- your script
local runner = require("eb.ic").new(env)
local w = runner:worldFacade()
w.markFight()                                    -- the pull: the fight clock starts
world.clock = world.clock + 3000
w.resetTimer("adds")                             -- what the reset_timer action does
world.clock = world.clock + 12000
print(("adds timer: %d ms since reset_timer"):format(w.timerElapsed("adds")))

-- check
DOCS.eq(w.timerElapsed("adds"), 12000, "a named timer counts from its reset")
DOCS.eq(w.timerElapsed(), 15000, "the default timer counts from the pull")
DOCS.check(w.detrimentPresent({ who = "group", type = "noxious" }), "a noxious detriment is on the group")
DOCS.check(not w.detrimentPresent({ type = "elemental" }), "no elemental one")
DOCS.check(w.chatSeen({ match = "the floor will burn" }), "the emote arrived since the pull")
DOCS.check(not w.chatSeen({ match = "the walls close in" }), "a line that never came")
DOCS.check(w.hasItem("a fixture tonic"), "the tonic is in the bags")
DOCS.eq(w.actorType("Overseer of Fixtures"), "NamedNPC", "the actor's type")
