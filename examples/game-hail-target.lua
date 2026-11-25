-- Hail an NPC
--
-- Target the NPC with TargetActor(id), then send the game's own hail with Execute("eq2execute hail"). Execute sends one console line as written: use it only for commands EB knows to work.
--
-- kind:      snippet
-- expect:    The quest giver is targeted and the hail goes out to the game.
-- verified:  on the offline stand-in for the game
-- in game:   use the code under '-- your script'. The lines above it build the test world and the
--            lines under '-- check' check the result: DOCS exists only in the docs test runner.
-- modules:   game
-- id:        game-hail-target

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
