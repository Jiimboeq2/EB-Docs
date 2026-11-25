-- EB tested example: A pack's gates: level, a held sibling, a zone's wing
-- quest-gates | snippet | topics: quests
--
-- What it does:  Before the first step the runner checks the pack's gates: level_required stops a character that is too low (with
--                the reason), skip_if_holding skips the quest while a sibling from the same giver is held. Zone names compare the
--                hub-aware way: a hub is never its own instance wing.
-- Tested:        The level gate blocks at level 20, the sibling gate completes as skipped, and the zone compares answer as the
--                game names zones.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
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
