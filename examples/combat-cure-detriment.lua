-- Cure only who carries the detriment
--
-- A cure entry for noxious detriments fires only on the member who carries one; an override's cure scope can rule group cures out for an encounter.
--
-- kind:      snippet
-- expect:    Member2 (noxious) is cured, Member1 (arcane only) is not a candidate; with the scope set to single, the group cure stays quiet.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.combat.heals, eb.combat.overrides, eb.combat
-- id:        combat-cure-detriment

-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
local FW = require("combat.lib.fightworld")
FW.book(w, { "Fixture Cleanse" })
w.addMember({ name = "Member1", id = 11, class = "guardian", healthPct = 90, powerPct = 80, inZone = true,
              afflict = { arcane = 1 } })
w.addMember({ name = "Member2", id = 12, class = "wizard", healthPct = 85, powerPct = 80, inZone = true,
              afflict = { noxious = 2 } })
w.addActor({ id = 11, name = "Member1", type = "PC", isNPC = false, distance = 5 })
w.addActor({ id = 12, name = "Member2", type = "PC", isNPC = false, distance = 6 })

-- your script
local game = require("eb.platform").game()
local cleanse = { name = "Fixture Cleanse", ability = "Fixture Cleanse", group = "cure", tags = "CURE",
                  target = "AllParty", priority = 50, gates = { cureTypes = "noxious" } }
local engine = require("eb.combat").new({ shim = game.combatShim(),
                                          stacks = require("eb.caststack.jsonstack").holder({ entries = { cleanse } }) })

local ctx = engine:snapshot()
local needs = {}
for _, row in ipairs(ctx.group) do needs[row.name or "?"] = engine:memberNeedsCure(row, cleanse) end
local d = engine:step()
print("cure: " .. tostring(d.reason))

engine:setOverride({ cureScope = "single" }, { name = "single cures only" })   -- an encounter rule
w.runFor(250)
local d2 = engine:step()
local scope, allowed = engine:effCureScope(), engine:cureScopeAllows(cleanse)
engine:clearOverride()

-- check
DOCS.eq(needs.Member2, true, "the noxious detriment matches this cure")
DOCS.eq(needs.Member1, false, "an arcane detriment does not")
DOCS.eq(d.kind, "cure", "the cure fires")
DOCS.eq(d.reason, "cure Member2", "on the member who carries it")
DOCS.eq(d2.hold, true, "scope single: the group cure is held")
DOCS.eq(scope, "single", "the override's cure scope")
DOCS.eq(allowed, false, "rules this group cure out")
