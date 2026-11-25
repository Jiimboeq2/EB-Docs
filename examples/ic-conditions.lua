-- EB tested example: Encounter conditions, and how they fail closed
-- ic-conditions | snippet | topics: instances, fights
--
-- What it does:  Evaluate when / done conditions against the runner's world facade: actor_present, actor_dead, actor_count,
--                health_below, the all / any / not_ combinators, and a function. A condition the runner does not know is always
--                false.
-- Tested:        Each condition reads the fake world as expected; the misspelled one is false, never a silent true.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
local env = require("instances.lib.icworld").make({ start = "copy",
    alive = { ["Captain Fixturo"] = 100 }, packs = { ["a hollow skitter"] = 2 } })
local runner = require("eb.ic").new(env)
local w = runner:worldFacade()                 -- what an encounter's conditions read through

local function holds(cond) return runner.evalCond(cond, w) end

DOCS.check(holds({ actor_present = "Captain Fixturo" }), "the named is up")
DOCS.check(not holds({ actor_dead = "Captain Fixturo" }), "so it is not dead")
DOCS.check(holds({ actor_count = { query = "a hollow skitter", cmp = ">=", value = 2 } }), "two skitters")
DOCS.check(not holds({ health_below = 40 }), "my health is not under 40%")
DOCS.check(holds({ any = { { health_below = 40 }, { actor_present = "Captain Fixturo" } } }), "any = one of them")
DOCS.check(not holds({ all = { { health_below = 40 }, { actor_present = "Captain Fixturo" } } }), "all = every one")
DOCS.check(holds({ not_ = { actor_present = "a missing mob" } }), "not_ flips one condition")
DOCS.check(holds(function(facade) return facade.actorCount("a hollow skitter") == 2 end), "a function reads the facade")
-- a `when` list means AND: every entry must hold
DOCS.check(runner.evalWhen({ { actor_present = "Captain Fixturo" }, { health_above = 50 } }, w), "a when list")

local misspelled = holds({ actor_presnet = "Captain Fixturo" })
print("unknown condition -> " .. tostring(misspelled))
DOCS.eq(misspelled, false, "an unknown condition is false: a typo never pulls a boss")
