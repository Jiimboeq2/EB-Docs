-- The loops' own decisions: an upgrade and a hire
--
-- The chore loops keep their choices in small pure functions you can call yourself: the trainer's next upgrade comes from YOUR priority list (exact name first, then a part of a name, and it never guesses), and the mercenary pick takes the cheapest offer of the role you ask for.
--
-- kind:      snippet
-- expect:    The trainer picks the first listed upgrade it may spend on, refuses to pick with no list, and the healer pick is the cheapest healer.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.loops.trainer, eb.loops.mercenary
-- id:        loop-pickers

local Trainer = require("eb.loops.trainer")
local Mercenary = require("eb.loops.mercenary")

local trainable = { { id = "t1", name = "Fixture Ward", kind = "training" },
                    { id = "t2", name = "Fixture Bloom", kind = "aa" } }
local pick = Trainer.pickNext(trainable, { "Fixture Bloom", "Fixture Ward" }, false)   -- AA spends not allowed
local withAA = Trainer.pickNext(trainable, { "Fixture Bloom", "Fixture Ward" }, true)
local none, why = Trainer.pickNext(trainable, {}, true)
print("next upgrade: " .. pick.name)

local offers = { { id = "k1", name = "a fixture guard", role = "tank", cost = 500 },
                 { id = "k2", name = "a fixture medic", role = "healer", cost = 400 },
                 { id = "k3", name = "a fixture nurse", role = "healer", cost = 350 } }
local hire = Mercenary.pickOffer(offers, "healer")
local wrong, whyRole = Mercenary.pickOffer(offers, "utility")

DOCS.eq(pick.id, "t1", "AA off: the first listed TRAINING upgrade")
DOCS.eq(withAA.id, "t2", "AA on: the list's own order decides")
DOCS.eq(none, nil, "no list: nothing is picked")
DOCS.has(why, "no train list", "the trainer never guesses an upgrade")
DOCS.eq(hire.id, "k3", "the cheapest healer")
DOCS.eq(wrong, nil, "never a wrong-role hire")
DOCS.has(whyRole, "utility", "it says which role was missing")
