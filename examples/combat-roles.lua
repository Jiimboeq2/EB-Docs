-- EB tested example: Aim at a role: Bard, DPS1, Healer1
-- combat-roles | snippet | topics: combat, crew
--
-- What it does:  A cast-stack entry can aim at a role instead of a name; the engine resolves it over the group of the same frame
--                by class order. Preview a buff on the Bard and a heal on DPS1.
-- Tested:        The buff aimed at Bard goes to the dirge, the heal aimed at DPS1 to the wizard (sorcerers come first).
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
FW.book(w, { "Fixture Song", "Fixture Mend" })
for i, m in ipairs({ { "Member1", "templar", 90 }, { "Member2", "dirge", 95 }, { "Member3", "wizard", 70 },
                     { "Member4", "ranger", 88 } }) do
    w.addMember({ name = m[1], id = 10 + i, class = m[2], healthPct = m[3], powerPct = 80, inZone = true })
    w.addActor({ id = 10 + i, name = m[1], type = "PC", isNPC = false, distance = 5 })
end

-- your script
local game = require("eb.platform").game()
local Combat = require("eb.combat")
local stack = require("eb.caststack.jsonstack").holder({ entries = {
    { name = "Fixture Song", ability = "Fixture Song", group = "buff", target = "Bard", priority = 40, gates = {} },
    { name = "Fixture Mend", ability = "Fixture Mend", group = "heal", target = "DPS1", priority = 50,
      gates = { useBelowTargetHP = 100 } },
} })
local engine = Combat.new({ shim = game.combatShim(), stacks = stack })
engine:loadStack()
local ctx = engine:snapshot()
local buff = engine:selectBuff(ctx)
local heal = engine:selectHeal(ctx)
local names = {}
for _, m in ipairs(game.Group()) do names[m.id] = m.name end
print(("Bard = %s, DPS1 = %s"):format(names[buff.target], names[heal.target]))

-- check
DOCS.eq(names[buff.target], "Member2", "Bard: the dirge")
DOCS.eq(names[heal.target], "Member3", "DPS1: the wizard (sorcerers come first)")
DOCS.eq(Combat.classOf({ subclass = "dirge" }), "bard", "a member's class as the roles read it")
DOCS.eq(Combat.isRoleToken("DPS2"), true, "DPS2 is a role")
DOCS.eq(Combat.isRoleToken("Member4"), false, "a name is not")
