-- EB tested example: React to a zone change
-- events-zoning | snippet | topics: events, helpers, nav
--
-- What it does:  Subscribe to ZoningStarted and ZoningFinished, and read the new zone only after the load has finished.
-- Tested:        The handlers see the start and the end of the load, and the zone read after the end is the new zone.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
