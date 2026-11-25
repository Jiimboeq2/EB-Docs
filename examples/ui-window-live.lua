-- Refresh a window from data that moves on its own
--
-- A live() signature is read at most every liveSec; a new signature rebuilds the state, an equal one costs nothing.
--
-- kind:      snippet
-- expect:    The window rebuilds when the snapshot's health changes and not while it stays the same.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   ebkit.window, eb.world, game
-- id:        ui-window-live

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ pulse = false, me = { healthPct = 90 } })

-- your script: a window that shows your health, built from the ONE world snapshot (never its own game reads)
local game = require("eb.platform").game()
local world = require("eb.world").new({ game = game })
local W = require("ebkit.window")
local builds = 0
local win = W.new({
    id = "myhealth", title = "My Health",
    build = function() builds = builds + 1; return { hp = world.snapshot().hpPct } end,
    live = function() return world.snapshot().hpPct end,     -- cheap: the snapshot is already built this frame
    liveSec = 1,
})
local first = win:state()
w.frame(70); world.beginTick()                                -- over a second later, nothing changed
local same = win:state()
w.self.healthPct = 55
w.frame(70); world.beginTick()
local changed = win:state()
print(("hp %d after the change"):format(changed.hp))

-- check
DOCS.check(first == same, "an equal signature: no rebuild")
DOCS.eq(changed.hp, 55, "a new signature: rebuilt")
DOCS.eq(builds, 2, "two builds in all")
