-- Read a pack's condition text yourself
--
-- eb.quest.cond reads the ${...} conditions packs carry, over a world snapshot: expand fills the terms, truth decides true, false or unknown, conditionExpr normalizes a bare condition first. A term EB cannot read is UNKNOWN - never a guess - and show() makes it readable (question marks).
--
-- kind:      snippet
-- expect:    The level and zone terms fill in, the comparison is true, and an unreadable term comes back unknown.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.quest.cond, eb.quest.quests
-- id:        quest-conditions-read

local cond = require("eb.quest.cond")

-- a world snapshot, as the runner hands one to every step
local snap = { level = 100, zone = "fixture_docks", x = 10, y = 0, z = 20 }
local env = { snap = snap }

-- your script
print(cond.expand("level ${Me.Level} in ${Zone.ShortName}", env))
local ok = cond.truth("${Me.Level} >= 20", env)
local wrapped = cond.conditionExpr("${Me.Level} >= 20")
local unknown = cond.truth("${Me.GetGameData[Self.Fixture].Label} == 3", env)
local kept = cond.expandKnown("go to ${Me.GetGameData[Self.Fixture].Label}", env)

-- the same reader a run uses, built over its journal and adapters
local deps = require("quests.lib.questworld").make()
local run = require("eb.quest.quests").bind(deps).start({ quest = { quest_name = "Fixture Walk", steps = {} } }, {})
local renv = require("eb.quest.quests").condEnv(run, snap)

-- check
DOCS.eq(ok, true, "the comparison holds")
DOCS.has(wrapped, "If[", "a comparison is wrapped before it is read")
DOCS.eq(unknown, nil, "an unreadable term is unknown, not false")
DOCS.eq(kept, nil, "expandKnown refuses a text with an unknown in it")
DOCS.check(not cond.show("a " .. cond.UNKNOWN .. " b"):find("\1", 1, true), "show() leaves no marker in the text")
DOCS.eq(cond.truth("${Me.Level} >= 20", renv), true, "the run's own reader answers the same")
