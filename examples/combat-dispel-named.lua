-- EB tested example: Strip a named's buff
-- combat-dispel-named | snippet | topics: combat, fights
--
-- What it does:  engine:dispel strips a mob's beneficial buff on cue with the stack's dispel art. The automatic dispel category
--                also needs the game's "has a buff to strip" read; a script supplies it here, and setDispelOn(false) stops it.
-- Tested:        The on-cue dispel goes out at the named; without a dispel art it says so; the automatic category casts the
--                dispel ahead of the rotation, until it is switched off.
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
FW.book(w, { "Fixture Purge", "Fixture Strike" })
FW.recastOnUse(w, 2)                                       -- the game shows each cast as taken: the ability goes on its reuse
FW.mob(w, { id = 300, name = "Overseer of Fixtures", type = "NamedNPC" })
FW.target(w, 300)

-- your script
local game = require("eb.platform").game()
local Combat = require("eb.combat")
local rows = { entries = function() return {
    { name = "Fixture Purge",  ability = "Fixture Purge",  group = "dps", tags = "DISPEL", priority = 10, gates = {} },
    { name = "Fixture Strike", ability = "Fixture Strike", group = "dps", tags = "CA",     priority = 90, gates = {} },
} end }
local engine = Combat.new({ shim = game.combatShim(), stacks = rows })

local status = engine:dispel({ mob = "Overseer" })         -- on cue: strip it now
print("dispel: " .. tostring(status))
local noArt = Combat.new({ shim = game.combatShim(), stacks = { entries = function() return {} end } }):dispel()

-- the automatic category: it needs the game to say the mob has something to strip
local shim = game.combatShim()
shim.dispellable = function(id) return id == 300 end      -- offline: that read (EB for InnerSpace has none yet)
local auto = Combat.new({ shim = shim, stacks = rows })
auto:loadStack()
w.runFor(2500)                                             -- the first dispel's recast has run out
local art = auto:dispelArt()
local d = auto:step()
auto:setDispelOn(false)
w.runFor(500)                                              -- a quick art goes out at most every half second
local d2 = auto:step()

-- check
DOCS.eq(status, "ok", "the on-cue dispel was sent")
DOCS.eq(FW.casts(w)[1], "Fixture Purge", "with the dispel art")
DOCS.eq(noArt, "no-dispel-art", "a stack without one says so and casts nothing")
DOCS.eq(art.ability, "Fixture Purge", "the art tagged DISPEL")
DOCS.eq(d.kind, "dispel", "the automatic dispel goes ahead of the rotation")
DOCS.eq(d2.ability, "Fixture Strike", "switched off: the rotation runs")
