-- A pack's gates: level, a held sibling, a zone's wing
--
-- Before the first step the runner checks the pack's gates: level_required stops a character that is too low (with the reason), skip_if_holding skips the quest while a sibling from the same giver is held. Zone names compare the hub-aware way: a hub is never its own instance wing.
--
-- kind:      snippet
-- expect:    The level gate blocks at level 20, the sibling gate completes as skipped, and the zone compares answer as the game names zones.
-- verified:  on the offline stand-in for the game
-- in game:   leave out the lines that use DOCS: they build the test world and check the result,
--            and DOCS exists only in the docs test runner.
-- modules:   eb.quest, eb.quest.gates
-- id:        quest-gates

local function firstStep(pack, opts, held)
    local deps, world = require("quests.lib.questworld").make(opts)
    if held then world.journal.give(held, { "a line" }) end
    local quests = require("eb.quest").bind(deps)
    return quests.step(quests.start({ quest = pack, name = pack.quest_name }, {}))
end

local st1, why1 = firstStep({ schema = "eb-quest/1", quest_name = "Fixture Trial", level_required = 60,
    steps = { { type = "command", command = "MM 1,0,1" } } }, { level = 20 })
print(why1)
local st2, why2 = firstStep({ schema = "eb-quest/1", quest_name = "Fixture Chore B", optional = true,
    skip_if_holding = { "Fixture Chore A" }, steps = { { type = "command", command = "MM 1,0,1" } } }, {}, "Fixture Chore A")

local G = require("eb.quest.gates")
DOCS.eq(st1, "blocked", "too low: the run stops")
DOCS.has(why1, "level 60 required", "and says so")
DOCS.eq(st2, "complete", "a held sibling: this one is skipped for now")
DOCS.has(why2, "sibling", "with the reason")
DOCS.check(G.zoneEqual("Fixture Hollow", "Fixture Hollow"), "a zone equals itself")
DOCS.check(not G.zoneEqual("Fixture Hollow", "Fixture Hollow: Heroic"), "a hub is not its wing")
DOCS.check(G.isInstanceZone("Fixture Hollow: Heroic"), "a ':' tag names an instance")
DOCS.check(G.flags({}).pack, "every quest is a pack (no fast travel) unless it says no_smart_travel = false")
