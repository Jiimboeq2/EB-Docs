-- Rez the fallen, then a power heal
--
-- A rez entry looks among the dead; once everyone is up, a power heal goes to the member under its power line, lowest first. On EB for InnerSpace the engine's group rows carry no power reading yet, so the script adds it.
--
-- kind:      snippet
-- expect:    The first step rezzes Member2; once everyone is up, the power heal goes to the lowest on power (Member2 at 20%, ahead of Member1 at 30%).
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.combat.heals, eb.combat, game
-- id:        combat-rez-and-power

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Revive", "Fixture Channel" })
FW.recastOnUse(w, 10)                         -- the game shows each cast as taken: the ability goes on its reuse
local m1 = w.addMember({ name = "Member1", id = 11, class = "guardian", healthPct = 90, powerPct = 30, inZone = true })
local m2 = w.addMember({ name = "Member2", id = 12, class = "wizard", healthPct = 0, powerPct = 0, inZone = true,
                         isDead = true })
w.addMember({ name = "Member3", id = 13, class = "ranger", healthPct = 80, powerPct = 85, inZone = true })
for id, name in pairs({ [11] = "Member1", [12] = "Member2", [13] = "Member3" }) do
    w.addActor({ id = id, name = name, type = "PC", isNPC = false, distance = 5 })
end

-- your script
local game = require("eb.platform").game()
local shim = game.combatShim()
local groupRows = shim.group
function shim.group()                         -- add each member's power from game.Group() (read in the same frame)
    local rows, power = groupRows(), {}
    for _, m in ipairs(game.Group()) do power[m.id] = m.powerPct end
    for _, r in ipairs(rows) do r.powerPct = r.powerPct or power[r.id] end
    return rows
end
local revive = { name = "Fixture Revive", ability = "Fixture Revive", group = "cure", tags = "REZ",
                 target = "AllParty", priority = 60, gates = {} }
local channel = { name = "Fixture Channel", ability = "Fixture Channel", group = "cure", tags = "POWER_HEAL",
                  target = "AllParty", priority = 50, gates = { belowPower = 50 } }
local engine = require("eb.combat").new({ shim = shim,
    stacks = require("eb.caststack.jsonstack").holder({ entries = { revive, channel } }) })

local d1 = engine:step()                                          -- the rez category comes before the power heals
m2.healthPct, m2.isDead, m2.powerPct = 40, false, 20              -- offline: Member2 accepts the rez
w.runFor(500)                                                     -- a quick art goes out at most every half second
local low = engine:needPower(engine:snapshot().group, channel)    -- who is under the power line, lowest first
local d2 = engine:step()
print("rez then power: " .. tostring(d1.ability) .. ", " .. tostring(d2.ability))

-- check
DOCS.eq(d1.kind, "rez", "a dead member is rezzed first")
DOCS.eq(d1.target, 12, "Member2")
DOCS.eq(low[1].name, "Member2", "after the rez Member2 is the lowest on power (20%)")
DOCS.eq(low[2].name, "Member1", "then Member1 (30%)")
DOCS.eq(#low, 2, "Member3 at 85% is not under the line")
DOCS.eq(d2.kind, "power", "then the power heal")
DOCS.eq(d2.target, 12, "on the lowest")
