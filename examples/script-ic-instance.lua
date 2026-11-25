-- A whole instance file: hub, door, route, camp spots, pulls, loop (complete script)
--
-- The instance.lua of a complete instance run: the hub and its door, the route STEPS the tank runs (camp spots for the group, walks, the trash pull, the named fight, the chest, the exit), a run option and the loop settings. Drop it in with its two encounter files and type eb ic run fixture_hollow.
--
-- kind:      complete script
-- file:      EB/data/eb/ic/<collection>/fixture_hollow/instance.lua
-- run:       eb ic run fixture_hollow
--            eb ic run fixture_hollow stay_inside=off
--            eb ic loop fixture_hollow 120
--            eb ic stop
-- needs:     EB running on every box of the group, the tank's box typing the command
--            the folder fixture_hollow in one of the collection folders under data/eb/ic (EB has none of its own yet)
--            its encounters folder beside instance.lua: encounters/hollow_skitters.lua, encounters/overseer_of_fixtures.lua
--            every box already in the hub zone (fixture_docks); the tank walks to the door and zones the group in
-- expect:    EB's eb ic run finds the file and starts the run as the lead; the same files run to completion through the instance runner: zoned in by the tank, the pack pulled and cleared, the named killed, the chest taken, the run ending inside (or out by the exit door with stay_inside=off), and two laps of the loop with the wait inside.
-- verified:  on the offline stand-in for the game
-- modules:   eb.ic, eb.app.ic
-- id:        script-ic-instance

-- fixture_hollow/instance.lua - one instance as data: nothing runs when EB loads it. The tank's box runs it: every
-- box gets to the hub on its own, the tank alone walks the hub to the door and zones the group in, then runs these
-- steps inside while the group holds on the tank's camp spots. Characters move only by walking the mesh.
return {
    schema = "eb.ic/1",
    zone = "Fixture Hollow",                  -- the display name
    short = "fixture_hollow",                 -- the short name the game gives the zone inside
    variants = { "[Heroic I]" },

    hub = {
        zone = "fixture_docks",               -- every box travels here first, each on its own
        difficulty = "[Heroic I]",            -- the copy the door is asked for (eb ic run fixture_hollow <difficulty> wins)
        approach = { { 10, 0, 10 }, { 20, 0, 25 } },          -- the tank's waypoints to the door; the mesh fills the gaps
        entrance = { loc = { 20, 0, 25 }, tolerance = 8 },   -- where the tank must stand to use the door
        door = { actor = "a fixture rift", verb = "enter" },
    },

    rules = "default",                        -- the character's own cast stack fights every pull
    encounters = { "hollow_skitters", "overseer_of_fixtures" },

    -- run options: an option that is ON skips its steps; type <id>=on|off after eb ic run / eb ic loop to flip one.
    -- stay_inside is on: the run ends inside the cleared copy, so eb ic loop waits out the timer THERE before it
    -- leaves by the exit and resets; eb ic run fixture_hollow stay_inside=off walks the group out at the end.
    options = {
        { id = "skip_trash", label = "Skip the skitter pack", default = false, skip_steps = { "trash" } },
        { id = "stay_inside", label = "End the run inside the cleared copy", default = true,
          skip_steps = { "to.exit", "exit" } },
    },

    route = {                                 -- the STEPS, in order
        { id = "camp.entry", act = "campspot", name = "entry", spot = { 0, 0, -30 }, who = "group" },
        { id = "to.pack", act = "path", spots = { { 0, 0, -10 }, { 0, 0, 5 } } },
        { id = "trash", act = "encounter", name = "hollow_skitters" },          -- the pull, then the clear
        { id = "camp.boss", act = "campspot", name = "boss room", spot = { 12, 0, 38 }, who = "group" },
        { id = "boss", act = "encounter", name = "overseer_of_fixtures" },      -- the named fight
        { id = "boss.loot", act = "loot", op = "chest" },
        { id = "said", act = "announce",
          message = "Fixture Hollow: trash {{verdict.trash}}, Overseer {{verdict.boss}}, chest {{verdict.boss.loot}}" },
        { id = "to.exit", act = "path", spots = { { 0, 0, -38 } } },           -- (both skipped while stay_inside is on)
        { id = "exit", act = "zoneout", via = "exit" },                        -- the tank takes the group out
    },

    -- eb ic loop: one zone, again and again; the tank waits out the timer INSIDE the cleared copy, then leaves by the
    -- exit, resets the copy from outside and goes back in. max_minutes 0 = until eb ic stop (the command's minutes win).
    loop = { reset = "self", rerun_first = false, max_minutes = 0 },
}
