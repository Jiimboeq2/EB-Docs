-- EB tested example: Cure a member on cue
-- fight-cure-on-cue | snippet | topics: fights, combat, crew
--
-- What it does:  Group rows carry each member's detriment counts (arcane, noxious, elemental, trauma, cursed); cure the one that
--                needs it, by name, once a tick.
-- Tested:        Only Member2 carries a noxious detriment; the cure goes out on Member2 by name and nobody else.
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
FW.book(w, { "Fixture Cure" })
for i, n in ipairs({ 0, 1, 0 }) do
    w.addMember({ name = "Member" .. i, id = 10 + i, class = "templar", healthPct = 80, powerPct = 70, inZone = true,
                  afflict = { noxious = n } })
    w.addActor({ id = 10 + i, name = "Member" .. i, type = "PC", isNPC = false, distance = 5 })
end

-- your script
local game = require("eb.platform").game()
for _, m in ipairs(game.Group()) do                      -- the other members (you are Me()), one batched read
    if (m.noxious or 0) > 0 and game.AbilityReady("Fixture Cure") then
        print(("curing %s (noxious %d)"):format(m.name, m.noxious))
        game.Cast("Fixture Cure", { name = m.name })
        break                                            -- one cure a tick
    end
end

-- check
DOCS.eq(#w.world.casts, 1, "one cure")
DOCS.eq(w.world.casts[1].target, "Member2", "on the member who needed it")
DOCS.eq(#game.Group(), 3, "three other members read")
