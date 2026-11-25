-- EB tested example: Read a pack's condition text yourself
-- quest-conditions-read | snippet | topics: quests
--
-- What it does:  eb.quest.cond reads the ${...} conditions packs carry, over a world snapshot: expand fills the terms, truth
--                decides true, false or unknown, conditionExpr normalizes a bare condition first. A term EB cannot read is
--                UNKNOWN - never a guess - and show() makes it readable (question marks).
-- Tested:        The level and zone terms fill in, the comparison is true, and an unreadable term comes back unknown.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
