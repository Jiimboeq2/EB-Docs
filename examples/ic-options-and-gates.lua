-- Instance options and step gates
--
-- An instance declares an option that skips its bonus named by default; a run flips it with skip_bonus=off. A route step with its own when gate runs only when the gate holds. A skipped step is said and never run.
--
-- kind:      snippet
-- expect:    The default run skips the bonus named and the gated chest; the run with skip_bonus=off fights it.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.ic
-- id:        ic-options-and-gates

local INSTANCE = {
    schema = "eb.ic/1", zone = "Fixture Hollow", short = "fixture_hollow",
    options = { { id = "skip_bonus", label = "skip the bonus named", default = true, skip_steps = { "bonus" } } },
    route = {
        { id = "bonus", act = "encounter", name = "bonus_named" },
        -- a step gate: loot the chest only when the bonus named is dead
        { id = "bonus.loot", act = "loot", op = "chest", when = { { actor_dead = "Old Fixturo" } } },
    },
}
local BONUS = { schema = "eb.ic/1", name = "Old Fixturo", kind = "named",
                phases = { { id = "pull", do_ = { { engage = "Old Fixturo" } } } } }

local function runWith(flags)
    local env, world = require("instances.lib.icworld").make({ start = "copy", alive = { ["Old Fixturo"] = 100 },
        drops = { "an old chest" } })
    env.loadInstance = function() return INSTANCE end
    env.loadEncounter = function() return BONUS end
    local runner = require("eb.ic").new(env)
    local inst = assert(runner:load("fixture_hollow"))
    local options = runner.parseOptionFlags(flags)       -- "skip_bonus=off" -> { skip_bonus = false }
    local ok, _, report = runner:run(inst, { options = options })
    return ok, report, world
end

local ok1, rep1, w1 = runWith("")
for _, l in ipairs(w1.lines) do if l:find("option skip_bonus", 1, true) then print(l) end end
local ok2, rep2, w2 = runWith("skip_bonus=off")

DOCS.check(ok1 and ok2, "both runs complete")
DOCS.eq(rep1.verdicts.bonus, nil, "default: the bonus named is skipped (no verdict)")
DOCS.eq(w1.did("chest"), 0, "default: its gate does not hold, so no chest step")
DOCS.eq(rep2.verdicts.bonus, "killed", "skip_bonus=off: the bonus named is fought")
DOCS.eq(rep2.verdicts["bonus.loot"], "an old chest", "and its gated chest is looted")
local flags, rest = require("eb.ic").parseOptionFlags("fixture_hollow 30 skip_bonus=off")
DOCS.eq(flags.skip_bonus, false, "parseOptionFlags takes the option words out")
DOCS.eq(rest, "fixture_hollow 30", "and hands back the rest of the line")
