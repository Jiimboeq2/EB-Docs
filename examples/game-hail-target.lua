-- EB tested example: Hail an NPC
-- game-hail-target | snippet | topics: game, quests, helpers, dialogs
--
-- What it does:  Target the NPC with TargetActor(id), then send the game's own hail with Execute("eq2execute hail"). Execute
--                sends one console line as written: use it only for commands EB knows to work.
-- Tested:        The quest giver is targeted and the hail goes out to the game.
-- Verified:      fake-host (tested offline: run end to end on EB's offline stand-in for the game; not run in the live game yet,
--                so try it on one box first)
-- In a script:   this is the whole tested file: EB's offline stand-in for the game (up to the -- your script line), the script,
--                and the checks (from the last -- check line, or the closing DOCS lines). A real script keeps only the script,
--                without its lines that use DOCS, w. or a. (the offline test world).
-- The docs:      https://github.com/Jiimboeq2/EB-Docs (EB_Scripting_Guide.md)
--
-- offline stand-in for the game (only the docs runner has DOCS; in game the world is real)
local w = DOCS.world()
w.addActor({ id = 310, name = "Questfixture", type = "NPC", distance = 5 })

-- your script
local game = require("eb.platform").game()
local npc = game.NearestActor('Type == "NPC"', 10, "Questfixture")
if npc and game.TargetActor(npc.id) then
    game.Execute("eq2execute hail")
    print("hailed " .. npc.name)
end

-- check
DOCS.eq(w.self.targetId, 310, "targeted first")
DOCS.eq(w.world.commands[#w.world.commands], "/hail", "then hailed")
