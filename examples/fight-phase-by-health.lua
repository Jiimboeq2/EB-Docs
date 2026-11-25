-- EB tested example: Change phase at a health mark
-- fight-phase-by-health | snippet | topics: fights, combat
--
-- What it does:  Watch the boss's health from a cheap pulse job and switch the cast stack once when it crosses a mark: burn rows
--                on at 30%.
-- Tested:        Above 30% the burn row stays off; the first read under 30% switches it on, exactly once.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
local boss = FW.mob(w, { id = 300, name = "the Ashen Overseer", type = "NamedNPC" })
FW.target(w, 300)
local JS = require("eb.caststack.jsonstack")
local holder = JS.holder(JS.build({ castStack = {          -- in game: eb.app.combat.holder, the character's own stack
    { slot = 1, name = "Fixture Burn", ability = "Fixture Burn", type = "CA", disabled = false, cond = { Tag = "BURN" } },
} }, { class = "warden" }))

-- your script
local game = require("eb.platform").game()
local switched = 0
holder.setTagEnabled("BURN", false)
require("eb.platform").pulse().every("phase watch", 250, function()
    local t = game.Target()                                   -- from the frame's one batched read
    if t and t.healthPct and t.healthPct < 30 and switched == 0 then
        holder.setTagEnabled("BURN", true)
        switched = switched + 1
        print(("phase 2 at %d%%"):format(t.healthPct))
    end
end)
boss.healthPct = 60; w.runFor(600)
local before = holder.entries()[1].disabled
boss.healthPct = 28; w.runFor(600)
boss.healthPct = 20; w.runFor(600)

-- check
DOCS.eq(before, true, "above the mark: still off")
DOCS.eq(holder.entries()[1].disabled, false, "under it: on")
DOCS.eq(switched, 1, "switched exactly once")
