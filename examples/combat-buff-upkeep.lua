-- EB tested example: Keep a buff up, keep the tank's ward up
-- combat-buff-upkeep | snippet | topics: combat, crew
--
-- What it does:  Preview what the upkeep and buff categories would cast - a ward kept on the tank, a buff that is not on you yet
--                - then see the buff skipped once its effect is up.
-- Tested:        The upkeep category keeps the ward on the guardian; the buff category casts the buff on you until its effect
--                shows, then stays quiet.
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
FW.book(w, { "Fixture Ward", "Fixture Regrowth" })
w.addMember({ name = "Member1", id = 11, class = "guardian", healthPct = 92, powerPct = 80, inZone = true })
w.addActor({ id = 11, name = "Member1", type = "PC", isNPC = false, distance = 5 })

-- your script
local game = require("eb.platform").game()
local stack = require("eb.caststack.jsonstack").holder({ entries = {
    { name = "Fixture Regrowth", ability = "Fixture Regrowth", group = "upkeep", target = "PartyTank", priority = 60,
      gates = {} },                                                -- kept on the tank
    { name = "Fixture Ward", ability = "Fixture Ward", group = "buff", target = "Me", priority = 40, gates = {} },
} })
local engine = require("eb.combat").new({ shim = game.combatShim(), stacks = stack })

engine:loadStack()                                                 -- what a step does first
local ctx = engine:snapshot()
local upkeep = engine:selectUpkeep(ctx)                            -- preview one category, without casting
local buff = engine:selectBuff(ctx)
w.world.buffNames = { "Fixture Ward" }                             -- offline: the buff landed on you
w.runFor(250)
local later = engine:selectBuff(engine:snapshot())
print(("upkeep on %s, buff on %s, then %s"):format(upkeep.reason:match("^(%S+)"),
    buff.target == w.self.id and "me" or tostring(buff.target), later and "more" or "nothing to buff"))

-- check
DOCS.eq(upkeep.kind, "upkeep", "the upkeep category")
DOCS.eq(upkeep.target, 11, "keeps the ward on the tank")
DOCS.eq(buff.kind, "buff", "the buff category")
DOCS.eq(buff.target, w.self.id, "casts the buff on you")
DOCS.eq(later, nil, "nothing to buff once it is up")
DOCS.eq(#FW.casts(w), 0, "a preview casts nothing")
