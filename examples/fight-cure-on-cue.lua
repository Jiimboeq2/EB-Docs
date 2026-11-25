-- Cure a member on cue
--
-- Group rows carry each member's detriment counts (arcane, noxious, elemental, trauma, cursed); cure the one that needs it, by name, once a tick.
--
-- kind:      snippet
-- expect:    Only Member2 carries a noxious detriment; the cure goes out on Member2 by name and nobody else.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        fight-cure-on-cue

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
