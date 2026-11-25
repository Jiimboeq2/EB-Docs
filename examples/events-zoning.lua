-- React to a zone change
--
-- Subscribe to ZoningStarted and ZoningFinished, and read the new zone only after the load has finished.
--
-- kind:      snippet
-- expect:    The handlers see the start and the end of the load, and the zone read after the end is the new zone.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.events, game
-- id:        events-zoning

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { zone = "a test hall" } })
local events = w.events()

-- your script
local game = require("eb.platform").game()
local log = {}
events.on("ZoningStarted", function()
    log[#log + 1] = "started"           -- the zone's name may already read the NEW zone here: never trust it yet
end)
events.on("ZoningFinished", function(ev)
    local zone = game.Me().zone         -- read after the end of the load: the new zone
    log[#log + 1] = "finished"
    print(("now in %s (the load took %s s)"):format(zone, tostring(ev.seconds)))
end)

-- the game loads a zone (offline: the fake host fires the game's own zoning events)
w.host:fire("EQ2_StartedZoning")
w.world.self.zone = "a fixture vault"
w.frame(2)
w.host:fire("EQ2_FinishedZoning", "3.5")
w.frame(2)

-- check
DOCS.eq(log[1], "started", "the start of the load")
DOCS.eq(log[2], "finished", "then its end")
DOCS.eq(game.Me().zone, "a fixture vault", "the zone read after the end")
