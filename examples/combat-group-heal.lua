-- EB tested example: A group heal waits for enough hurt members
-- combat-group-heal | snippet | topics: combat, crew
--
-- What it does:  A group heal entry gated on "2 members under 70%" stays quiet for one scratch and fires once two members are
--                under the line - on the lowest of them.
-- Tested:        With one member under 70% there is no group heal; with two, it fires on Member2, the lowest.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world({ me = { healthPct = 95 } })
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Renewal" })
local rows = {}
for i, m in ipairs({ { "Member1", "guardian", 90 }, { "Member2", "wizard", 40 }, { "Member3", "ranger", 80 } }) do
    rows[i] = w.addMember({ name = m[1], id = 10 + i, class = m[2], healthPct = m[3], powerPct = 80, inZone = true })
    w.addActor({ id = 10 + i, name = m[1], type = "PC", isNPC = false, distance = 5 })
end

-- your script
local game = require("eb.platform").game()
local renewal = { name = "Fixture Renewal", ability = "Fixture Renewal", group = "heal", target = "AllParty",
                  priority = 50, gates = { groupHealTargetsBelowHP = 70, groupHealMinTargets = 2 } }
local engine = require("eb.combat").new({ shim = game.combatShim(),
                                          stacks = require("eb.caststack.jsonstack").holder({ entries = { renewal } }) })

engine:loadStack()
local oneHurt = engine:healChoice(engine:snapshot(), renewal)      -- only Member2 is under 70%
rows[3].healthPct = 60                                             -- offline: Member3 takes a hit
w.runFor(200)                                                      -- a later frame reads the group fresh
local d = engine:step()
print(("group heal: %s (%s)"):format(d.ability, d.reason))

-- check
DOCS.eq(oneHurt, nil, "one member under the line: no group heal")
DOCS.eq(d.kind, "heal", "two under the line: the group heal fires")
DOCS.eq(d.reason, "Member2 at 40%", "on the lowest of them")
