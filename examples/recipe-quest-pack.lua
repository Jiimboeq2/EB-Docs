-- Recipe: a quest pack with stages, hails and clicks
--
-- Write a quest pack, bind the quest runner, and drive it to completion the way EB's brain does: travel by the zone's own transit, walk, hail the giver through its dialog, click the quest objects until the journal updates, kill and loot, then hand in. Each stage advances on the journal's own text.
--
-- kind:      snippet
-- expect:    The pack runs to complete; the journal shows each stage in turn and the quest leaves the journal at the hand-in.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   eb.quest
-- id:        recipe-quest-pack

-- the pack: what a quest file returns (pure data; each step is one command line)
local PACK = {
    schema = "eb-quest/1",
    quest_name = "The Fixture Errand",
    no_smart_travel = true,                  -- a pack never fast travels (this is also the default)
    steps = {
        { type = "comment", description = "Stage 1: take the errand from the warden" },
        { type = "command", command = 'CheckZone "Fixture Vale"' },           -- the zone's own transit, never fast travel
        { type = "command", command = "MM 12,0,30" },                         -- walk the mesh to the warden
        { type = "command", command = "HailActor Warden Fixturo,1,1" },       -- hail, then dialog picks 1 and 1
        { type = "command", command = 'CheckQuestStep "Collect three fixture lanterns"' },
        { type = "comment", description = "Stage 2: the lanterns and the thief" },
        { type = "command", command = 'DoubleClickActorUntilUpdate "a fixture lantern"',
          completed = "Collect three fixture lanterns" },                     -- click until the journal ticks it
        { type = "command", command = 'KillMobs "a lantern thief","",30,5', completed = "Defeat the lantern thief" },
        { type = "command", command = "LootAll" },
        { type = "comment", description = "Stage 3: back to the warden" },
        { type = "command", command = 'CheckQuestStep "Return to Warden Fixturo"' },
        { type = "command", command = "HailActor Warden Fixturo,1" },         -- the hand-in
        { type = "command", command = "QuestComplete" },                      -- verified: the quest left the journal
    },
}

-- offline stand-in: a scripted world (in game the journal, the NPCs and the fights are real)
local QUEST = PACK.quest_name
local lanterns = 0
local deps, world = require("quests.lib.questworld").make({
    onHail = function(npc, picks, w)
        if not w.quests[QUEST] and not w.completed[QUEST] then
            w.journal.give(QUEST, { "Collect three fixture lanterns", "Defeat the lantern thief" })
        elseif w.quests[QUEST] then w.journal.complete(QUEST) end            -- the hand-in
    end,
    onClick = function(spec, w)
        lanterns = lanterns + 1
        if lanterns >= 3 then w.journal.check(QUEST, "Collect three fixture lanterns") end
    end,
    onKill = function(target, w) w.journal.check(QUEST, "Defeat the lantern thief"); w.lootPending = true end,
    onLoot = function(w) w.journal.stage(QUEST, { "Return to Warden Fixturo" }) end,   -- stage 3 shows up
})

-- your script: bind the runner to its adapters, start the pack, and drive it one step per tick
local quests = require("eb.quest").bind(deps)
local run = quests.start({ quest = PACK, name = QUEST }, {})
local trace, status, info = {}, nil, nil
for _ = 1, 100 do
    status, info = quests.step(run)
    trace[#trace + 1] = status
    if status == "complete" or status == "blocked" then break end
    -- the brain's part: the runner hands travel, fights and loot back, and the brain does them
    if status == "need_travel" then deps.nav.travelTo(info, { pack = true })
    elseif status == "need_combat" then deps.combat.engage(info); world.hated = false
    elseif status == "need_loot" then deps.economy.lootGrab({}) end
    world.tick(5000)
end
print(status .. ": " .. tostring(info))

-- check
DOCS.eq(status, "complete", "the pack ran to its end")
DOCS.check(world.completed[QUEST], "the quest left the journal at the hand-in")
DOCS.eq(world.did("travel"), 1, "one trip, by the zone's own transit")
DOCS.eq(world.did("hail"), 2, "two hails: the giver and the hand-in")
DOCS.eq(lanterns, 3, "clicked until the journal ticked the lanterns")
DOCS.eq(world.did("engage"), 1, "one pull for the thief")
DOCS.eq(world.did("loot"), 1, "one loot pass")
local seen = table.concat(trace, " ")
DOCS.has(seen, "need_travel", "travel was handed to the brain")
DOCS.has(seen, "need_combat", "the fight was handed to the brain")
DOCS.has(seen, "need_loot", "the loot was handed to the brain")
