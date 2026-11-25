-- How EB scores a piece of gear
--
-- eco.gearup:score(item, role) ranks Resolve first, then Fervor, then Potency, then the role's main stat (fighter stamina, priest wisdom, mage intelligence, scout agility), then any weights you set in cfg.gear, with item level only breaking a tie. roleOf(me) is the character's archetype.
--
-- kind:      snippet
-- expect:    One point of Resolve outweighs any Fervor, Fervor outweighs Potency, a priest prefers wisdom, and a configured weight counts too.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.economy.gearup, eb.economy
-- id:        gear-score

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
