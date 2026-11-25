-- EB tested example: How EB scores a piece of gear
-- gear-score | snippet | topics: items
--
-- What it does:  eco.gearup:score(item, role) ranks Resolve first, then Fervor, then Potency, then the role's main stat (fighter
--                stamina, priest wisdom, mage intelligence, scout agility), then any weights you set in cfg.gear, with item level
--                only breaking a tie. roleOf(me) is the character's archetype.
-- Tested:        One point of Resolve outweighs any Fervor, Fervor outweighs Potency, a priest prefers wisdom, and a configured
--                weight counts too.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline: the economy facade for a templar, with an extra weight for the "haste" stat
local eco = require("eb.economy").new({ drive = {}, me = { subclass = "templar" }, cfg = { gear = { priest = { haste = 2 } } } })

-- your script
local role = eco.gearup:roleOf()
local s = function(stats, ilvl) return eco.gearup:score({ stats = stats, ilvl = ilvl or 0 }, role) end
local resolve, fervor, potency = s({ resolve = 1 }), s({ fervor = 999 }), s({ potency = 999 })
local wisdom, stamina = s({ wisdom = 50 }), s({ stamina = 50 })
print(("role %s: resolve > fervor > potency > wisdom"):format(role))

-- check
DOCS.eq(role, "priest", "a templar is a priest")
DOCS.check(resolve > fervor and fervor > potency and potency > wisdom, "the strict order")
DOCS.check(wisdom > stamina, "a priest's main stat is wisdom")
DOCS.check(s({ haste = 10 }) > s({}), "a configured weight counts")
DOCS.check(s({ wisdom = 50 }, 90) > s({ wisdom = 50 }, 80), "item level breaks a tie")
