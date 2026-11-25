-- A named fight with a gate, phases, a reaction and a win test (complete script)
--
-- encounters/overseer_of_fixtures.lua of the complete instance: the fight starts only when the named is up and nobody is fighting; the tank fights it to death while reactive phases answer its emote (the group steps onto a safe ledge and back), clear its adds and cast the finisher under 30%; the fight counts as won only when it is dead.
--
-- kind:      complete script
-- file:      EB/data/eb/ic/<collection>/fixture_hollow/encounters/overseer_of_fixtures.lua
-- run:       eb ic run fixture_hollow
-- needs:     the instance file fixture_hollow/instance.lua, whose route step "boss" names this file
--            Fixture Burst (or your own finisher's name) in the tank's knowledge book
-- expect:    The emote moves the group to the safe ledge once and back, the adds are cleared, the finisher is cast once under 30%, and the verdict is killed; with the named not up, the gate skips the fight.
-- verified:  on the offline stand-in for the game
-- modules:   eb.ic
-- id:        script-named-fight

-- fixture_hollow/encounters/overseer_of_fixtures.lua - one named fight as conditions -> actions. The phases without a
-- "when" run in order; a phase with "when" + "repeat_ = true" is a REACTION, checked between phases and on every tick
-- of the fight; "once = true" fires a reaction one time per pull.
return {
    schema = "eb.ic/1",
    name = "Overseer of Fixtures",
    aka = { "the Overseer" },
    kind = "named",
    spot = { 12, 0, 42 },                                 -- where the tank fights it from

    -- the GATE: the named is up and nobody is fighting yet (else the verdict is "skipped:gate")
    when = { { actor_present = "Overseer of Fixtures" }, { in_combat = false } },

    phases = {
        -- the fight: the cast stack fights the Overseer to death; the reactions below fire on its ticks
        { id = "fight", do_ = { { engage = "Overseer of Fixtures" } } },

        -- REACTION to the emote: the floor burns - the group steps onto the safe ledge, waits it out, comes back
        { id = "floor", repeat_ = true, once = true,
          when = { { chat_seen = { match = "the floor will burn" } } },
          do_ = {
              { campspot = { name = "safe ledge", spot = { 25, 0, 50 }, who = "group" } },
              { wait = 6 },
              { campspot = { name = "boss room", spot = { 12, 0, 38 }, who = "group" } },
          } },

        -- REACTION to adds: whenever spawns are up, clear them
        { id = "adds", repeat_ = true,
          when = { { actor_count = { query = "a fixture spawn", cmp = ">=", value = 1 } } },
          do_ = { { clear_area = "a fixture spawn", radius = 25 } } },

        -- the BURN: under 30% health, cast the finisher once
        { id = "burn", repeat_ = true, once = true,
          when = { { mob_health_below = { name = "Overseer of Fixtures", pct = 30 } } },
          do_ = { { cast = "Fixture Burst" } } },
    },

    -- the WIN TEST: the fight only counts as won when the Overseer is dead (else "FAILED:done-test")
    done = { { actor_dead = "Overseer of Fixtures" } },

    -- a wipe here: say so before the walk back in
    on_death = { { announce = "the Overseer of Fixtures wiped us - walking back in" } },
}
