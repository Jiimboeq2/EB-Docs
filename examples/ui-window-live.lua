-- EB tested example: Refresh a window from data that moves on its own
-- ui-window-live | snippet | topics: ui, perf
--
-- What it does:  A live() signature is read at most every liveSec; a new signature rebuilds the state, an equal one costs
--                nothing.
-- Tested:        The window rebuilds when the snapshot's health changes and not while it stays the same.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
